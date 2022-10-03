//
//  WeatherForcastCell.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 03/10/2022.
//

import UIKit

// MARK: - WeatherForcastCell

final class WeatherForcastCell: UITableViewCell {
    private enum Constant {
        static let horizontalContstraint: CGFloat = 16
        static let labelStackViewSpacing: CGFloat = 8
        static let labelNumberOfLines: Int = 2
        static let weatherIconImageViewHeightConstraint: CGFloat = 30
        static let weatherIconImageViewWidthConstraint: CGFloat = 30
    }

    // MARK: - IBOutlets

    var forcastDayLabel = UILabel()
    var temperatureLabel = UILabel()
    var weatherIconImageView = UIImageView()
    private let labelStackView = UIStackView()

    // MARK: - Life Cycle Methods

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension WeatherForcastCell {
    func initializeView() {
        selectionStyle = .none

        weatherIconImageView.contentMode = .scaleAspectFit
        weatherIconImageView.clipsToBounds = true
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(weatherIconImageView)

        addSubview(forcastDayLabel)
        forcastDayLabel.translatesAutoresizingMaskIntoConstraints = false
        forcastDayLabel.textColor = .white
        forcastDayLabel.textAlignment = .left
        forcastDayLabel.numberOfLines = Constant.labelNumberOfLines

        addSubview(temperatureLabel)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.textColor = .white
        temperatureLabel.textAlignment = .right
        temperatureLabel.numberOfLines = Constant.labelNumberOfLines

        addSubview(labelStackView)
        labelStackView.addArrangedSubview(forcastDayLabel)
        labelStackView.addArrangedSubview(weatherIconImageView)
        labelStackView.addArrangedSubview(temperatureLabel)
        labelStackView.axis = .horizontal
        labelStackView.distribution = .fillEqually
        labelStackView.alignment = .center
        labelStackView.spacing = Constant.labelStackViewSpacing
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            weatherIconImageView.heightAnchor.constraint(
                equalToConstant: Constant.weatherIconImageViewHeightConstraint),
            weatherIconImageView.widthAnchor.constraint(
                equalToConstant: Constant.weatherIconImageViewWidthConstraint)
        ])

        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constant.horizontalContstraint
            ),
            labelStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Constant.horizontalContstraint
            ),
            labelStackView.topAnchor.constraint(
                equalTo: topAnchor
            ),
            labelStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            )
        ])
    }
}
