//
//  JuegoTapVC.swift
//  GameJam2016
//
//  Created by Giacomo Preciado on 1/30/16.
//  Copyright © 2016 kyrie. All rights reserved.
//

import UIKit

class JuegoTapVC : UIViewController
{
	@IBOutlet weak var barraProgreso: UIView!
	@IBOutlet weak var anchoBarraProgreso: NSLayoutConstraint!
	@IBOutlet weak var tiempoRestante: UILabel!
	@IBOutlet weak var etiquetaTextbox: UILabel!
	@IBOutlet weak var spoiler: UIView!
	
	let botonJugador = UIView()
	let botonEfecto = UIView()
	let botonToque = UIButton()
	let diametroBoton = CGFloat(40)
	var segundosJuego = 30
	
	var dictTeclado = [Character : CGPoint]()
	var textoAEscribir = ""
	var indiceLetra = 0
	var temporizador = NSTimer()
	var segundosTranscurridos = 0
	var ganó = false
	
	var fase = 0
	
	override func viewDidLoad()
	{
		let subviews = view.subviews
	
        let pantalla = UIScreen.mainScreen().bounds
        let pantallaDiseñada = CGSize(width: 320.0, height: 568.0)
        let proporcionModificada = pantalla.width / pantallaDiseñada.width
        
        for subview in subviews
		{
			if let boton = subview as? UIButton
			{
				let letra = boton.titleLabel?.text!
				
                var frameBoton = boton.frame
                frameBoton.size = CGSize(
                    width: frameBoton.size.width * proporcionModificada,
                    height: frameBoton.size.height * proporcionModificada)
                
                frameBoton.origin = CGPoint(
                    x: frameBoton.origin.x * proporcionModificada,
                    y: frameBoton.origin.y * proporcionModificada)
                
                if proporcionModificada == 1.0
                {
                    frameBoton.origin.y += pantalla.height - pantallaDiseñada.height
                }
                
                boton.frame = frameBoton
                
				dictTeclado[letra!.characters.first!] = boton.center
				boton.hidden = true
                
                boton.backgroundColor = UIColor.redColor()
                
			}
		}

		botonJugador.frame.size = CGSizeMake(diametroBoton, diametroBoton)
		botonJugador.layer.cornerRadius = diametroBoton / 2
		botonJugador.clipsToBounds = true
		botonJugador.backgroundColor = UIColor.darkGrayColor()

		botonEfecto.frame.size = botonJugador.frame.size
		botonEfecto.layer.cornerRadius = botonJugador.layer.cornerRadius
		botonEfecto.clipsToBounds = true
		botonEfecto.backgroundColor = UIColor.greenColor()

		botonToque.frame.size = CGSizeMake(diametroBoton * 1.5, diametroBoton * 1.5)
		
		botonToque.addTarget(self, action: Selector("tapEnBoton:"), forControlEvents: .TouchUpInside)

		spoiler.alpha = 0.0
		view.addSubview(botonEfecto)
		view.addSubview(botonJugador)
		view.addSubview(botonToque)
		
		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		fase = delegate.fase
		
		let textos = [
			"hola que tal ",
			"jajajajaja mira un easter egg ",
			"ya mucho vicio tengo que irme "
		]
		
		let tiempos = [
			30,
			30,
			30,
		]
		textoAEscribir = textos[fase]
		segundosJuego = tiempos[fase]
		
		mostrarSiguienteLetra()
		
		// Timer
		
		temporizador = NSTimer(timeInterval: 1,
			target: self,
			selector: Selector("segundo:"),
			userInfo: nil,
			repeats: true)
		
		NSRunLoop.mainRunLoop().addTimer(temporizador, forMode: NSRunLoopCommonModes)
	}
	
	func mostrarSiguienteLetra()
	{
		let indice = textoAEscribir.characters.startIndex.advancedBy(indiceLetra)
		let letra = textoAEscribir[indice]
		mostrarBotonConLetra(letra)
	}
	
	
	func mostrarBotonConLetra(letra : Character)
	{
		let centroBoton = dictTeclado[letra]!
		botonJugador.center = centroBoton
		botonEfecto.center = centroBoton
		botonToque.center = centroBoton
		
		botonEfecto.transform = CGAffineTransformIdentity
		botonEfecto.alpha = 1.0
		
		UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
			self.botonEfecto.transform = CGAffineTransformMakeScale(2.5, 2.5)
			self.botonEfecto.alpha = 0.0
		}) { (completion) -> Void in
		}

	}
	
	func tapEnBoton(boton : UIButton)
	{
		if fase == 2
		{
			UIView.animateWithDuration(0.1) { () -> Void in
				self.spoiler.alpha = self.spoiler.alpha + 0.1
			}
		}
			
		indiceLetra++
		if indiceLetra >= textoAEscribir.characters.count
		{
			temporizador.invalidate()
			ganaste()
			
			boton.enabled = false
		}
		else
		{
			let index = textoAEscribir.startIndex.advancedBy(indiceLetra)
			etiquetaTextbox.text = textoAEscribir.substringToIndex(index)
			mostrarSiguienteLetra()
		}
			
		let anchoPantalla = view.frame.width
		
		self.anchoBarraProgreso.constant = CGFloat(self.indiceLetra) / CGFloat(self.textoAEscribir.characters.count) * anchoPantalla
		
		UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
			self.view.layoutIfNeeded()
			}, completion: nil)

		
	}
	
	func segundo(timer: NSTimer)
	{
		segundosTranscurridos++
		determinarSegundosRestantes()

		
		if(segundosTranscurridos == segundosJuego)
		{
			timer.invalidate()
			perdiste()
			print("perdiste")
		}
	}
	
	func determinarSegundosRestantes()
	{
		let segundosRestantes = self.segundosJuego - self.segundosTranscurridos
		
		let texto =  segundosRestantes < 10 ?
			"00:0\(segundosRestantes)" : "00:\(segundosRestantes)"
		tiempoRestante.text = texto
		
	}
	
	func ganaste()
	{
		ganó = true
		performSegueWithIdentifier(Constantes.SegueFinDeJuego, sender: self)
		
	}
	
	func perdiste()
	{
		ganó = false
		performSegueWithIdentifier(Constantes.SegueFinDeJuego, sender: self)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		let finDeJuego = segue.destinationViewController as! FinDeJuegoVC
		finDeJuego.finDeJuego(ganó, subtitulo: "Continúa con tu aventura")
	}
	
}