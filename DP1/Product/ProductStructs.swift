//
//  ProductStructs.swift
//  DP1
//
//  Created by Sergii Kotyk on 3/6/21.
//

import Foundation

struct ProductValue: Codable {
    let name, englishName, sortOrder, article: String
    let productDescription, colorName, colorImageURL, mainImage: String
    let productImages: [ProductImage]
    let offers: [Offer]
    let price: String
    let attributes: [Attribute]

    enum CodingKeys: String, CodingKey {
        case name, englishName, sortOrder, article
        case productDescription = "description"
        case colorName, colorImageURL, mainImage, productImages, offers, price, attributes
    }
}


struct Attribute: Codable {
    let womenParametrs, manParametrs, season, consist: String?
    let country, care, element: String?

    enum CodingKeys: String, CodingKey {
        case womenParametrs = "Параметры модели жен."
        case manParametrs = "Параметры модели муж."
        case season = "Сезон"
        case consist = "Состав"
        case country = "Страна производителя"
        case care = "Уход за вещами"
        case element = "Декоративный элемент"
    }
}


struct Offer: Codable {
    let size, productOfferID, quantity: String
}


struct ProductImage: Codable {
    let imageURL, sortOrder: String
}

// создание кастомного класса
typealias Product = [String: ProductValue]
