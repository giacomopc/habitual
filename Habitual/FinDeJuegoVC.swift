//
//  FinDeJuegoVC.swift
//  GameJam2016
//
//  Created by Giacomo Preciado on 1/30/16.
//  Copyright © 2016 kyrie. All rights reserved.
//

import UIKit

class FinDeJuegoVC : UIViewController
{
	@IBOutlet weak var resultado: UILabel!
	@IBOutlet weak var etiquetaSubtitulo: UILabel!
	
	var jugadorGanó  = false
	var textoSubtitulo = ""
	
	override func viewDidLoad() {
		resultado.text = jugadorGanó ? "¡Ganaste!" : "¡No lo lograste!"
		etiquetaSubtitulo.text = textoSubtitulo
	}
	
	func finDeJuego(jugadorGanó : Bool, subtitulo : String)
	{
		self.jugadorGanó = jugadorGanó
		textoSubtitulo = jugadorGanó ? subtitulo : "Íntentalo de nuevo. No pierdes nada, sólo tiempo."
	}
	
	@IBAction func regresar(sender: AnyObject) {
		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let seleccionDeNivel = delegate.seleccionDeNivel!
		self.navigationController?.popToViewController(seleccionDeNivel, animated: true)
		
		if self.jugadorGanó
		{
			seleccionDeNivel.jugadorPasoNivel(0)
		}
	}
	
	
}