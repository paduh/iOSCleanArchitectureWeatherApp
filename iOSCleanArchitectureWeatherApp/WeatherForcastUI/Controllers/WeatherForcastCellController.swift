//
//  WeatherForcastCellController.swift
//  iOSCleanArchitectureWeatherApp
//
//   Created by Perfect Aduh on 03/10/2022.
//  Copyright © 2022 Perfect Aduh. All rights reserved.
//

import UIKit

// MARK: - WeatherForcastCellController

final class WeatherForcastCellController: NSObject {

    private var viewModel: FiveDaysWeatherForcastViewModelDelegate

    init(viewModel: FiveDaysWeatherForcastViewModelDelegate) {
        self.viewModel = viewModel
    }

    func view() -> UITableViewCell {
        let cell = binded(WeatherForcastCell())
        return cell
    }

    private func binded(_ cell: WeatherForcastCell) -> WeatherForcastCell {
        cell.forcastDayLabel.text = viewModel.forcastDayTitle
        cell.temperatureLabel.text = viewModel.temperatureTitle
        switch viewModel.weatherType {
        case .rain:
            cell.backgroundColor = UIColor.init(named: "rainy-colour")
            cell.weatherIconImageView.image = UIImage(named: "rain")
        case .clear:
            cell.backgroundColor = UIColor.init(named: "sunny-colour")
            cell.weatherIconImageView.image = UIImage(named: "clear")
        case .clouds:
            cell.backgroundColor = UIColor.init(named: "cloudy-colour")
            cell.weatherIconImageView.image = UIImage(named: "partlysunny")
        default:
            break
        }
        return cell
    }
}
