//
//  SeleccionDeNivelVC.swift
//  GameJam2016
//
//  Created by Giacomo Preciado on 1/30/16.
//  Copyright © 2016 kyrie. All rights reserved.
//

import UIKit

class SeleccionDeNivelVC : UIViewController
{
	@IBOutlet weak var tablaNiveles: UIView!
	@IBOutlet weak var instruccion: UILabel!
	@IBOutlet weak var titulo: UILabel!
	@IBOutlet weak var tiempos: UILabel!
	@IBOutlet weak var imagenHome: UIImageView!
	@IBOutlet weak var iniciar: UIButton!
	
	var botones = [UIButton]()
	var puntosCreados = [UIView]()
	
	let iMessage = [65, 210, 90]
	let calendar = [220, 220, 220]
	let fotos = [242, 107, 102]
	let camara = [176, 143, 148]
	let reloj = [30, 30, 31]
	let notas = [255, 214, 50]
	let appStore = [27, 178, 249]
	let iBooks = [252, 139, 13]
	let whatsApp = [47, 214, 81]
	let mail = [28, 156, 247]
	let calc = [255, 149, 0]
	let facebook = [67, 98, 165]
	let nineGag = [0, 0, 0]
	let alphaBotonApagado = CGFloat(0.15)
	
	let llaveMejorTiempo = "mejorTiempo"
	
	var coloresBotones = [[Int]]()
	var ultimoIndiceBoton = 0
	var primeraVez = true
	var comenzarJuego = false
	var finalJuego = false
	var detenerSecuenciaIntro = false
	var nivel = 0
	var tiempoInicioJuego : NSTimeInterval = 0.0
	
	let secuenciaNiveles = [0, 12, 8, 2, 11, 0, 12, 2]
	let fases = [0, 0, 1, 0, 1, 2, 2, 1]
	let tipoNiveles = ["type", "scroll", "type", "refresh", "scroll", "type", "scroll", "refresh"]

	override func viewDidLoad() {
		
		coloresBotones = [
			iMessage, calendar, mail, fotos,
			camara,	reloj, notas, appStore,
			iBooks, whatsApp, calc, facebook,
			nineGag]

		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		delegate.seleccionDeNivel = self
		
		print("cargó menú")
		
		let separacion = CGFloat(13)
		let nBotonesPorFila = 4
		let anchoBoton = (view.frame.width - CGFloat(nBotonesPorFila + 1) * separacion) / CGFloat(nBotonesPorFila)

		
		// Cargar mejor tiempo, si hay
		let mejorTiempo = NSUserDefaults.standardUserDefaults().doubleForKey(llaveMejorTiempo)
		if mejorTiempo > 0.0
		{
			tiempos.hidden = false
			tiempos.text = String(format: "Mejor tiempo: %.02f", arguments: [mejorTiempo])
		}
		

		for i in 0 ..< coloresBotones.count
		{
			let columna = i % nBotonesPorFila
			let fila = i / nBotonesPorFila
			let frameBoton = CGRect(
				x: separacion + (anchoBoton + separacion) * CGFloat(columna),
				y: (separacion + 15.0 + anchoBoton) * CGFloat(fila),
				width: anchoBoton,
				height: anchoBoton)
			let boton = UIButton(frame: frameBoton)
			let colorRGB = coloresBotones[i]
			boton.backgroundColor = UIColor(
				red: CGFloat(colorRGB[0]) / 255.0,
				green: CGFloat(colorRGB[1]) / 255.0,
				blue: CGFloat(colorRGB[2])  / 255.0,
				alpha: 1.0)
			
			boton.tag = i
			
			boton.addTarget(self, action: Selector("presionoBoton:"), forControlEvents: .TouchUpInside)
			boton.addTarget(self, action: Selector("touchDown:"), forControlEvents: .TouchDown)
			boton.addTarget(self, action: Selector("touchUp:"), forControlEvents: .TouchUpInside)
			
			boton.layer.cornerRadius = 5
			boton.clipsToBounds = true
			boton.alpha = alphaBotonApagado
			
			boton.titleLabel?.font = UIFont.systemFontOfSize(28)
			
			tablaNiveles.addSubview(boton)
			botones.append(boton)
			
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		
		if(primeraVez)
		{
			var i = 0;
			for boton in botones
			{
				boton.transform = CGAffineTransformMakeScale(0, 0)
				
				UIView.animateWithDuration(0.3 + 0.05 * Double(i), animations: { () -> Void in
					boton.transform = CGAffineTransformIdentity
				})
				i++
			}
			
			comenzarAnimacion()
			primeraVez = false
		}
		
		
		// Terminó el juego
		if nivel == secuenciaNiveles.count
		{
			finalJuego = true
			
			imagenHome.alpha = 0.0
			imagenHome.hidden = false
			
			UIView.animateWithDuration(2.0, animations:
			{ () -> Void in
				self.imagenHome.alpha = 1.0
			})

			titulo.alpha = 0.0
			instruccion.alpha = 0.0
			tiempos.alpha = 0.0
		}
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		print("touchesBegan")
		
		if finalJuego
		{
				
			UIView.animateWithDuration(2.0, animations:
			{ () -> Void in
				self.titulo.alpha = 1.0
				
				self.tiempos.alpha = 1.0
				self.iniciar.alpha = 1.0
				self.iniciar.transform = CGAffineTransformIdentity
			})
			
			finalJuego = false
		}
	}
	
	func comenzarAnimacion()
	{
		var i1 = 0
		var i2 = 0

		i1 = ultimoIndiceBoton
		
		if comenzarJuego
		{
			i2 = 0
			detenerSecuenciaIntro = true
		}
		else
		{
			repeat
			{
				i2 = indiceDeBotonAleatorio()
			} while (i1 == i2)
		}
		realizarAnimacion(i1, indiceBoton2: i2)
	}
	
	func indiceDeBotonAleatorio() -> Int
	{
		return Int(arc4random() % UInt32(coloresBotones.count))
	}
	let TiempoAnimacion = 0.15
	func touchDown(boton: UIButton)
	{
		boton.transform = CGAffineTransformIdentity
		
		UIView.animateWithDuration(TiempoAnimacion) { () -> Void in
			boton.transform = CGAffineTransformMakeScale(0.8, 0.8)
		}
	}
	
	func touchUp(boton: UIButton)
	{
		UIView.animateWithDuration(TiempoAnimacion) { () -> Void in
			boton.transform = CGAffineTransformIdentity
		}
	}
	
	func presionoBoton(boton : UIButton)
	{
		print("presiono boton \(boton.tag)")
	
		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		delegate.fase = fases[nivel]
		print("FASE \(delegate.fase)")
		
		if boton.tag == secuenciaNiveles[nivel] && comenzarJuego
		{
			performSegueWithIdentifier(tipoNiveles[nivel], sender: self)
		}
		
		UIView.animateWithDuration(TiempoAnimacion) { () -> Void in
			boton.transform = CGAffineTransformIdentity
		}
	}
	
	func realizarAnimacion(indiceBoton1 : Int, indiceBoton2: Int)
	{

		ultimoIndiceBoton = indiceBoton2
		
		if(indiceBoton1 == indiceBoton2)
		{
			print("ERROR: 1==2")
			return
		}
		
		let boton1 = botones[indiceBoton1]
		let boton2 = botones[indiceBoton2]
		
		let c1 = boton1.center
		let c2 = boton2.center
		
		let direccionAnimacion = CGPointMake(c2.x - c1.x, c2.y - c1.y)
		
		let distanciaEntrePuntos = CGFloat(12.0)
		let cuadrados = sqrt(direccionAnimacion.x * direccionAnimacion.x +
			direccionAnimacion.y * direccionAnimacion.y)
		let nPuntos = max(Int(cuadrados / distanciaEntrePuntos), 3)
		
		let tamanoPunto = CGFloat(8)
		
		let posInicial = c1
		
		let tDuracion = Double(1.5)
		let tEntrePuntos = Double(0.05)
		
		UIView.animateWithDuration(1.0, delay: 0.01, options: .CurveEaseInOut, animations: { () -> Void in
			boton1.alpha = 1.0
			boton2.alpha = 1.0
		}, completion: { (completed) -> Void in })
		
		for i in 0..<nPuntos
		{
			let t = CGFloat(i) / CGFloat(nPuntos - 1)
			let posPunto = CGPointMake(posInicial.x + direccionAnimacion.x * t, c1.y + direccionAnimacion.y * t)
			let punto = UIView(frame: CGRectMake(0, 0, tamanoPunto, tamanoPunto))
			punto.layer.cornerRadius = tamanoPunto / 2.0
			punto.clipsToBounds = true
			punto.center = posPunto
			punto.backgroundColor = UIColor.grayColor()
			punto.transform = CGAffineTransformMakeScale(0, 0)
			puntosCreados.append(punto)
			tablaNiveles.addSubview(punto)
			tablaNiveles.sendSubviewToBack(punto)
			
			UIView.animateWithDuration(0.3, delay: tEntrePuntos * Double(i), options: .CurveEaseInOut, animations: { () -> Void in
				punto.transform = CGAffineTransformIdentity

				}, completion: { (completed) -> Void in })
			
			UIView.animateWithDuration(0.3, delay: tDuracion + tEntrePuntos * Double(i), options: .CurveEaseInOut, animations: { () -> Void in
				punto.transform = CGAffineTransformMakeScale(0.01, 0.01)

				}, completion: { (completed2) -> Void in
				punto.removeFromSuperview()
			})
		}
		
		
		UIView.animateWithDuration(1.0, delay: tDuracion + tEntrePuntos * Double(1), options: .CurveEaseInOut, animations: { () -> Void in
			boton1.alpha = self.alphaBotonApagado

		}, completion: { (completed) -> Void in })
		
		if !detenerSecuenciaIntro
		{
			let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64((tDuracion + 0.05 + tEntrePuntos * Double(nPuntos)) * Double(NSEC_PER_SEC)))
			dispatch_after(delayTime, dispatch_get_main_queue()) {
				self.comenzarAnimacion()
			}
		}
	}
	
	@IBAction func Iniciar(sender: UIButton) {
		
		print("iniciar")
		
		let primerBoton = botones[secuenciaNiveles[nivel]]
		primerBoton.setTitle("1", forState: .Normal)
		
		if nivel != 0
		{
			for boton in botones
			{
				boton.enabled = true
				boton.alpha = self.alphaBotonApagado
				boton.setTitle("", forState: .Normal)
			}
			
			nivel = 0
			
			primerBoton.alpha = 1.0
		}
		
		tiempoInicioJuego = NSDate.timeIntervalSinceReferenceDate()

		
		comenzarJuego = true
		// Animaciones
		
		UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseIn, animations: { () -> Void in
			sender.transform = CGAffineTransformMakeScale(0.01,0.01)
			sender.alpha = 0.0
			self.tiempos.alpha = 0.0
		}) { (completed) -> Void in
				
		}
		
		
		UIView.animateWithDuration(0.5, delay: 2.0, options: .CurveEaseOut, animations: { () -> Void in
			self.instruccion.alpha = 1.0
			self.imagenHome.alpha = 0.0
			}) { (completed) -> Void in
				self.imagenHome.hidden = true
		}
	}
	
	func jugadorPasoNivel(nivelPasado: Int)
	{
		print("pasó nivel")
		nivel++
		
		if nivel < secuenciaNiveles.count
		{
			realizarAnimacion(
				secuenciaNiveles[nivel - 1],
				indiceBoton2: secuenciaNiveles[nivel]
			)
			
			botones[secuenciaNiveles[nivel]].setTitle("\(nivel + 1)", forState: .Normal)
			
			detenerSecuenciaIntro = true
		}
		else
		{
			print("termino todo el juego")
			
			tiempos.hidden = false
			
			let userDefaults = NSUserDefaults.standardUserDefaults()
			let tiempoDeEsteJuego = NSDate.timeIntervalSinceReferenceDate() - tiempoInicioJuego

			var mejorTiempo = userDefaults.doubleForKey(llaveMejorTiempo)
			
			if tiempoDeEsteJuego < mejorTiempo || userDefaults.objectForKey(llaveMejorTiempo) == nil
			{
				mejorTiempo = tiempoDeEsteJuego
				userDefaults.setDouble(mejorTiempo, forKey: llaveMejorTiempo)
				userDefaults.synchronize()
			}
			
			tiempos.text = String(format: "Tu tiempo: %.02f\nMejor tiempo: %.02f", arguments: [tiempoDeEsteJuego, mejorTiempo])
			
			for boton in botones
			{
				boton.enabled = false
			}
		}
	}
}