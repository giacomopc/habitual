//
//  ViewController.swift
//  GameJam2016
//
//  Created by Giacomo Preciado on 1/29/16.
//  Copyright © 2016 kyrie. All rights reserved.
//

import UIKit

class JuegoScrollVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var teFaltan: UILabel!
    @IBOutlet weak var like: UIImageView!
	
	var temporizador = NSTimer()
	
	var nCeldas = 100
	var segundosJuego = 30

	var textoEnCelda = ""
	var segundosTranscurridos = 0
	var colorEnCelda = [Bool]()
	var ganó = false
	
	var fase = 0
	var alphas = 0.0
	
	override func viewDidLoad() {
		
		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		fase = delegate.fase
		
		tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)

		determinarSegundosRestantes()
		
		let duracionJuego = [30, 45, 59]
		segundosJuego = duracionJuego[fase]
		
		let celdasPorFase = [70, 70, 50]
		nCeldas = celdasPorFase[fase]
		
		
		for _ in 0 ..< nCeldas
		{
			colorEnCelda.append(false)
		}
		
		let celdasPintadasPorFase = [
			[1, 5, 12, 20, 39, 40, 41, 60, 69, 99, 115, 128],
			[1, 4, 6, 25, 39, 41, 60, 69, 99, 115, 150, 169, 183],
			[10, 15, 16, 22, 29, 34, 42]
		]
		
		
        // facil
//		let celdasPintadasPorFase = [
//			[1, 2,4,5],
//			[1, 5],
//			[10, 20]
//		]
		
		let indicesCeldasPintadas = celdasPintadasPorFase[fase]
		
		for indiceCelda in indicesCeldasPintadas
		{
			if(indiceCelda < nCeldas)
			{
				colorEnCelda[indiceCelda]  = true
			}
		}
		
		actualizarTeFaltan()
		
		temporizador = NSTimer(timeInterval: 1,
			target: self,
			selector: Selector("segundo:"),
			userInfo: nil,
			repeats: true)
		
		NSRunLoop.mainRunLoop().addTimer(temporizador, forMode: NSRunLoopCommonModes)
		
		actualizarTeFaltan()
	}
	
	func actualizarTeFaltan()
	{
		var celdasPintadas = 0
		
		for celdaPintada in colorEnCelda
		{
			if celdaPintada { celdasPintadas++ }
		}
		
		if celdasPintadas == 0 // ganaste
		{

			temporizador.invalidate()
			print("ganaste")
			ganaste()
			
		}
		
		
		teFaltan.text = "Te falta encontrar \(celdasPintadas) cuadrados"
		
		if celdasPintadas == 1
		{
			teFaltan.text = "Te falta encontrar \(celdasPintadas) cuadrado"
		}
	}
	
	func determinarSegundosRestantes()
	{
		let segundosRestantes = self.segundosJuego - self.segundosTranscurridos
		
		textoEnCelda =  segundosRestantes < 10 ?
			"00:0\(segundosRestantes)" :
			"00:\(segundosRestantes)"
	}
	
	func segundo(timer: NSTimer)
	{
		segundosTranscurridos++
		determinarSegundosRestantes()
		
		dispatch_async(dispatch_get_main_queue()) { () -> Void in

			let celdasVisibles = self.tableView.visibleCells as! [CeldaConEtiqueta]
			for celda in celdasVisibles {
				celda.etiqueta.text = self.textoEnCelda
			}
		}
		
		if(segundosTranscurridos == segundosJuego)
		{
			timer.invalidate()
			perdiste()
			print("perdiste")
		}
	}
	

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return nCeldas
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let identificador = "idCelda"
		var celda = tableView.dequeueReusableCellWithIdentifier(identificador) as? CeldaConEtiqueta
		
		if celda == nil
		{
			celda = CeldaConEtiqueta(style: .Default, reuseIdentifier:  identificador)
			celda?.imagenFondo.alpha = CGFloat(alphas)
		}
		
		let indice = indexPath.row
		
		if let celda = celda
		{
			if fase != 2 { celda.colorFrontal.alpha = 1}
			celda.colorFrontal.backgroundColor = colorEnCelda[indice] ? UIColor(red: 0.0, green: 0.2, blue: 0.7, alpha: 1.0) : UIColor.grayColor()
			
			if fase == 2 {
			 	celda.colorFrontal.alpha = colorEnCelda[indice] ? 0.4 : 0.0	
			}
				
			celda.imagenFondo.alpha = CGFloat(alphas)
			celda.etiqueta.text = textoEnCelda
			
			let nombreImagen = "gag\(indice % 6).PNG"
			celda.imagenFondo.image = UIImage(named: nombreImagen)
		}
		
		return celda!
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 400
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

		let indice = indexPath.row
		let celda = tableView.cellForRowAtIndexPath(indexPath) as? CeldaConEtiqueta
		
		if colorEnCelda[indice]
		{
			celda?.colorFrontal.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0)
			colorEnCelda[indice] = false
//			alphas += 0.1
			actualizarTeFaltan()
			
			if (fase == 2)
			{
				like.hidden = false
				like.alpha = 1.0
				like.transform = CGAffineTransformIdentity
				UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
					self.like.transform = CGAffineTransformMakeScale(2.0, 2.0)
					self.like.alpha = 0.0
				}, completion: { (completion) -> Void in
						self.like.hidden = true
				})
			}
		}
		else
		{
//			celda?.fondo.backgroundColor = UIColor.redColor()
		}
		

	}

	func scrollViewDidScroll(scrollView: UIScrollView) {
		if fase == 2
		{
			alphas += 0.01
			for celda in tableView.visibleCells
			{
				let celdaConEtiqueta = celda as! CeldaConEtiqueta
				celdaConEtiqueta.imagenFondo.alpha = CGFloat(self.alphas)
			}
		}
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

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		print("prepareforsegue")
		let finDeJuego = segue.destinationViewController as! FinDeJuegoVC
		
		
		finDeJuego.finDeJuego(ganó, subtitulo: "Deslizaste por tu pantalla 700 kilómetros")
	}
	
}

