//
//  JuegoRefreshVC.swift
//  GameJam2016
//
//  Created by Giacomo Preciado on 1/31/16.
//  Copyright © 2016 kyrie. All rights reserved.
//

import UIKit

class JuegoRefreshVC : UIViewController, UIScrollViewDelegate
{
	var vistaInstrucciones : UIImageView!
	var vistaInstruccionesSuelta : UIImageView!
	var etiquetaObjetivo : UILabel!
	var vistaSpoiler : UIImageView!
	var indicadorActividad : UIActivityIndicatorView!
	
	var nivel = 0
	var fase = 0
	
	var textos : [String] = []
	
	let textosFases =
	[
		[
			"bien!",
			"sigue así!!",
			"Cada vez que deslizas tu dedo, limpias tu pantalla.",
			"La verdad sólo la\ndejas más grasosa...",
			"Ganaste!! Ahora limpia tu pantalla."
		],
		[
			"volviste!",
			"no desesperes!",
			"sólo una vez más",
			""
		]
	]
	
	let distanciaEntreNiveles = 80
	
	
	override func viewDidLoad() {

		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		fase = delegate.fase
		
		textos = textosFases[fase]
		
		// Barra
		let altoBarra = CGFloat(65)
		let frameBarra = CGRectMake(0, 0, view.frame.width, altoBarra)
		let barra = UIView(frame: frameBarra)
		barra.backgroundColor = UIColor(red: 64.0 / 255.0, green: 140.0 / 255.0, blue: 150.0 / 255.0, alpha: 1.0)
		
		
		let frameScrollView = CGRectMake(0, altoBarra, view.frame.width, view.frame.height - altoBarra)
		let scrollView = UIScrollView(frame: frameScrollView)
		scrollView.delegate = self
		let frameVistaInterna = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 1000.0)
		
		let vistaImagen = UIImageView(frame: frameVistaInterna)
		vistaImagen.image = UIImage(named: "contenido.png")
		
		let frameInstrucciones = CGRectMake(0, 0, scrollView.frame.width, scrollView.frame.width)
		vistaInstrucciones = UIImageView(frame: frameInstrucciones)
		vistaInstrucciones.image = UIImage(named: "instrucciones3.png")
		vistaInstrucciones.contentMode = .ScaleToFill
		
		vistaInstruccionesSuelta = UIImageView(frame: frameInstrucciones)
		vistaInstruccionesSuelta.image = UIImage(named: "instrucciones4.png")
		vistaInstruccionesSuelta.contentMode = .ScaleToFill
		vistaInstruccionesSuelta.hidden = true
		
		let frameEtiquetaNumero = CGRectMake(0, 0, view.frame.width, 80)
		etiquetaObjetivo = UILabel(frame: frameEtiquetaNumero)
		etiquetaObjetivo.textAlignment = .Center
		etiquetaObjetivo.font = UIFont.boldSystemFontOfSize(25)
		etiquetaObjetivo.numberOfLines = 2

		let imagenSpoiler = UIImage(named: "inboxContenido.png")
		vistaSpoiler = UIImageView(frame: CGRectMake(0, 0, view.frame.width,
			imagenSpoiler!.size.height / imagenSpoiler!.size.width * view.frame.width))
		vistaSpoiler.contentMode = .ScaleAspectFill
		vistaSpoiler.image = imagenSpoiler
		vistaSpoiler.alpha = 0.0
		
		indicadorActividad = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
		indicadorActividad.color = UIColor.grayColor()
		scrollView.addSubview(indicadorActividad)
		indicadorActividad.startAnimating()
		indicadorActividad.hidden = true
		indicadorActividad.hidesWhenStopped = false

		
		// Agregar las vistas
		view.addSubview(barra)
		view.addSubview(scrollView)
		scrollView.addSubview(vistaImagen)
		scrollView.addSubview(vistaInstrucciones)
		scrollView.addSubview(vistaInstruccionesSuelta)
		scrollView.addSubview(etiquetaObjetivo)
		scrollView.addSubview(vistaSpoiler)
		scrollView.addSubview(indicadorActividad)
		
		scrollView.contentSize = frameVistaInterna.size
		
		crearSiguienteNumero()
	}
	
	func crearSiguienteNumero()
	{
		etiquetaObjetivo.center = CGPointMake(view.frame.width / 2, -CGFloat((nivel + 1) * distanciaEntreNiveles))
		
		let texto = textos[nivel]
		etiquetaObjetivo.text = texto
		
		// indicadorActividad
		indicadorActividad.center = etiquetaObjetivo.center
		indicadorActividad.hidden = (fase == 0 || texto != "")
		
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		
		let yOffset = scrollView.contentOffset.y
		
		let limite = yOffset < CGFloat(-distanciaEntreNiveles * (nivel + 1))
		vistaInstruccionesSuelta.hidden = !limite
		vistaInstrucciones.hidden = limite
	}
	
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		scrollView.userInteractionEnabled = true
		
		if nivel >= textos.count
		{
			if fase == 0
			{
				ganaste()
			}
			else
			{
				scrollView.scrollEnabled = false
				
				let boton = UIButton(type: .Custom)
				boton.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
				boton.addTarget(self, action: Selector("finalizar:"), forControlEvents: .TouchUpInside)
				scrollView.addSubview(boton)
			}
		}
		else
		{
			crearSiguienteNumero()
		}

	}
	
	func finalizar(sender: UIButton)
	{
		ganaste()
	}
	
	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		print("scrollViewDidEndDragging")
		let yOffset = scrollView.contentOffset.y
		let limite = yOffset < CGFloat(-distanciaEntreNiveles * (nivel + 1))
		if limite
		{
			nivel++
			
			if nivel >= textos.count && fase == 1
			{
				UIView.animateWithDuration(0.5, animations: { () -> Void in
					self.vistaSpoiler.alpha = 1.0
				})
			}
			
			scrollView.userInteractionEnabled = false
		}
		else
		{
			print("NO paso nivel")
		}
	}
	
	var ganó = false
	
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
		finDeJuego.finDeJuego(ganó, subtitulo: "La pantalla te lo agradece")
	}
}