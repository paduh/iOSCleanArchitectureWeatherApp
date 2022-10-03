//
//  WeatherForcastHeaderView.swift
//  iOSCleanArchitectureWeatherApp
//
//  Created by Perfect Aduh on 03/10/2022.
//

import UIKit

final class WeatherForcastHeaderView: UIView {
    private enum Constant {
        static let horizontalContstraint: CGFloat = 16
        static let feedImageContainerVeritcalConstaint: CGFloat = 8
        static let feedImageContainerHorizontalConstaint: CGFloat = 8
        static let feedImageContainerHeightConstaint: CGFloat = 200
        static let temperatureLabelStackViewSpacing: CGFloat = 8
        static let containerViewHeightConstaint: CGFloat = 60
        static let topImageViewTopConstraint: CGFloat = 100
        static let labelNumberOfLines: Int = 2
        static let fontLableSize: CGFloat = 40
    }

    private var viewModel: CurrentDayWeatherForcastViewModel?

    private let topImageView = UIImageView()
    private let currentTempLabel = UILabel()
    private let largeCurrentTempLabel = UILabel()
    private let minTempLabel = UILabel()
    private let maxTempLabel = UILabel()
    private let temperatureLabelStackView = UIStackView()
    private let stackViewContainerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        addConstraints()
    }

    func setup(with viewModel: CurrentDayWeatherForcastViewModel) {
        self.viewModel = viewModel

        currentTempLabel.text = "\(viewModel.temperatureTitle ?? "")° \nCurrent"
        maxTempLabel.text = "\(viewModel.maxTemperatureTitle ?? "")° \nMax"
        minTempLabel.text = "\(viewModel.minTemperatureTitle ?? "")° \nMin"
        largeCurrentTempLabel.text = "\(viewModel.temperatureTitle ?? "")° \n\(viewModel.weatherTitle ?? "")"

        switch viewModel.weatherType {
        case .rain:
            stackViewContainerView.backgroundColor = UIColor.init(named: "rainy-colour")
            topImageView.image = UIImage(named: "sea_rainy")
        case .clear:
            stackViewContainerView.backgroundColor = UIColor.init(named: "sunny-colour")
            topImageView.image = UIImage(named: "sea_sunny")
        case .clouds:
            stackViewContainerView.backgroundColor = UIColor.init(named: "cloudy-colour")
            topImageView.image = UIImage(named: "sea_cloudy")
        default: break
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension WeatherForcastHeaderView {
    func initializeView() {
        topImageView.contentMode = .scaleAspectFill
        topImageView.clipsToBounds = true
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topImageView)

        addSubview(currentTempLabel)
        currentTempLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTempLabel.textColor = .white
        currentTempLabel.textAlignment = .center
        currentTempLabel.numberOfLines = Constant.labelNumberOfLines

        addSubview(minTempLabel)
        minTempLabel.translatesAutoresizingMaskIntoConstraints = false
        minTempLabel.textColor = .white
        minTempLabel.textAlignment = .left
        minTempLabel.numberOfLines = Constant.labelNumberOfLines

        addSubview(maxTempLabel)
        maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTempLabel.textColor = .white
        maxTempLabel.textAlignment = .right
        maxTempLabel.numberOfLines = Constant.labelNumberOfLines

        addSubview(largeCurrentTempLabel)
        largeCurrentTempLabel.translatesAutoresizingMaskIntoConstraints = false
        largeCurrentTempLabel.textColor = .white
        largeCurrentTempLabel.textAlignment = .center
        largeCurrentTempLabel.numberOfLines = Constant.labelNumberOfLines
        largeCurrentTempLabel.font = UIFont(name: largeCurrentTempLabel.font.fontName, size: Constant.fontLableSize)

        temperatureLabelStackView.addArrangedSubview(minTempLabel)
        temperatureLabelStackView.addArrangedSubview(currentTempLabel)
        temperatureLabelStackView.addArrangedSubview(maxTempLabel)
        temperatureLabelStackView.axis = .horizontal
        temperatureLabelStackView.distribution = .fillEqually
        temperatureLabelStackView.alignment = .fill
        temperatureLabelStackView.spacing = Constant.temperatureLabelStackViewSpacing
        temperatureLabelStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackViewContainerView)
        stackViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        stackViewContainerView.addSubview(temperatureLabelStackView)
    }

    func addConstraints() {

        NSLayoutConstraint.activate([
            largeCurrentTempLabel.centerXAnchor.constraint(
                equalTo: topImageView.centerXAnchor
            ),
            largeCurrentTempLabel.centerYAnchor.constraint(
                equalTo: topImageView.centerYAnchor
            )
        ])

        NSLayoutConstraint.activate([
            topImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            topImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            topImageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: -Constant.topImageViewTopConstraint
            ),
            topImageView.heightAnchor.constraint(equalToConstant: Constant.feedImageContainerHeightConstaint)
        ])

        NSLayoutConstraint.activate([
            stackViewContainerView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            stackViewContainerView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            stackViewContainerView.topAnchor.constraint(
                equalTo: topImageView.bottomAnchor
            ),
            stackViewContainerView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: Constant.feedImageContainerVeritcalConstaint
            ),
            stackViewContainerView.heightAnchor.constraint(equalToConstant: Constant.containerViewHeightConstaint)
        ])

        NSLayoutConstraint.activate([
            temperatureLabelStackView.leadingAnchor.constraint(
                equalTo: stackViewContainerView.leadingAnchor,
                constant: Constant.horizontalContstraint
            ),
            temperatureLabelStackView.trailingAnchor.constraint(
                equalTo: stackViewContainerView.trailingAnchor,
                constant: -Constant.horizontalContstraint
            ),
            temperatureLabelStackView.topAnchor.constraint(
                equalTo: stackViewContainerView.topAnchor
            ),
            temperatureLabelStackView.bottomAnchor.constraint(
                equalTo: stackViewContainerView.bottomAnchor
            )
        ])
    }
}
