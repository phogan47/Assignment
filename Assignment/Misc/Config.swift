//
//  Config.swift
//  Assignment
//
//  Created by Patrick Hogan on 15/12/2020.
//

import UIKit

struct Config {
	static let baseURL = "https://api.themoviedb.org/"
	static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
	static let apiKey = "cff5552d53f08c373d8a6562ccc981a5"

	struct Colors {
		static let mainTheme = UIColor(red: 0 / 255, green: 155 / 255, blue: 255 / 255, alpha: 1.00)
		static let navBarTint = mainTheme
		static let navBarText = UIColor.white
	}
}
