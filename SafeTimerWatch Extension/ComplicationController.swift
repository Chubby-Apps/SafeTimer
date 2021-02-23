//
//  ComplicationController.swift
//  SafeTimerWatch Extension
//
//  Created by Asier G. Morato on 14/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import ClockKit
import CoreData
import CloudKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
    }

    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }

    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }

    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        handler(nil)
    }

    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }

    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
	
	func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
		// This method will be called once per supported complication, and the results will be cached
		switch(complication.family) {
		case .modularSmall:
			guard let image = UIImage(named: "Modular") else { handler(nil); return}
			let template = CLKComplicationTemplateExtraLargeSimpleImage(imageProvider:CLKImageProvider(onePieceImage: image))
			handler(template)
		case .utilitarianSmall:
			guard let image = UIImage(named: "Utilitarian") else { handler(nil); return}
			let template = CLKComplicationTemplateUtilitarianSmallSquare(imageProvider:CLKImageProvider(onePieceImage: image))
			
			template.imageProvider = CLKImageProvider(onePieceImage: image)
			handler(template)
		case .circularSmall:
			guard let image = UIImage(named: "Circular") else { handler(nil); return}
			let template = CLKComplicationTemplateExtraLargeSimpleImage(imageProvider:CLKImageProvider(onePieceImage: image))
			handler(template)
		case .extraLarge:
			guard let image = UIImage(named: "Extra Large") else { handler(nil); return}
			let template = CLKComplicationTemplateExtraLargeSimpleImage(imageProvider:CLKImageProvider(onePieceImage: image))
			handler(template)
		case .graphicCorner:
			guard let image = UIImage(named: "Graphic Corner") else { handler(nil); return}
			let template = CLKComplicationTemplateGraphicCircularImage(imageProvider:CLKFullColorImageProvider(fullColorImage: image))
			handler(template)
		case .graphicCircular:
			guard let image = UIImage(named: "Graphic Circular") else { handler(nil); return}
			let template = CLKComplicationTemplateGraphicCircularImage(imageProvider:CLKFullColorImageProvider(fullColorImage: image))
			handler(template)
		default:
			handler(nil)
		}
	}
	
	func getAlwaysOnTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
		// This method will be called once per supported complication, and the results will be cached
		switch(complication.family) {
		case .modularSmall:
			guard let image = UIImage(named: "Modular") else { handler(nil); return}
			let template = CLKComplicationTemplateExtraLargeSimpleImage(imageProvider:CLKImageProvider(onePieceImage: image))
			handler(template)
		case .utilitarianSmall:
			guard let image = UIImage(named: "Utilitarian") else { handler(nil); return}
			let template = CLKComplicationTemplateUtilitarianSmallSquare(imageProvider:CLKImageProvider(onePieceImage: image))
			
			template.imageProvider = CLKImageProvider(onePieceImage: image)
			handler(template)
		case .circularSmall:
			guard let image = UIImage(named: "Circular") else { handler(nil); return}
			let template = CLKComplicationTemplateExtraLargeSimpleImage(imageProvider:CLKImageProvider(onePieceImage: image))
			handler(template)
		case .extraLarge:
			guard let image = UIImage(named: "Extra Large") else { handler(nil); return}
			let template = CLKComplicationTemplateExtraLargeSimpleImage(imageProvider:CLKImageProvider(onePieceImage: image))
			handler(template)
		case .graphicCorner:
			guard let image = UIImage(named: "Graphic Corner") else { handler(nil); return}
			let template = CLKComplicationTemplateGraphicCircularImage(imageProvider:CLKFullColorImageProvider(fullColorImage: image))
			handler(template)
		case .graphicCircular:
			guard let image = UIImage(named: "Graphic Circular") else { handler(nil); return}
			let template = CLKComplicationTemplateGraphicCircularImage(imageProvider:CLKFullColorImageProvider(fullColorImage: image))
			handler(template)
		default:
			handler(nil)
		}
	}
	
	func getComplicationTemplate(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {
		switch(complication.family) {
		case .modularSmall:
			guard let image = UIImage(named: "Modular") else {return nil}
			let template = CLKComplicationTemplateExtraLargeSimpleImage(imageProvider: CLKImageProvider(onePieceImage: image))
			return template
		case .utilitarianSmall:
			guard let image = UIImage(named: "Utilitarian") else {return nil}
			let template = CLKComplicationTemplateUtilitarianSmallSquare(imageProvider:CLKImageProvider(onePieceImage: image))
			return template
		case .circularSmall:
			guard let image = UIImage(named: "Circular") else {return nil}
			let template = CLKComplicationTemplateExtraLargeSimpleImage(imageProvider: CLKImageProvider(onePieceImage: image))
			return template
		case .extraLarge:
			guard let image = UIImage(named: "Extra Large") else {return nil}
			let template = CLKComplicationTemplateExtraLargeSimpleImage(imageProvider:CLKImageProvider(onePieceImage: image))
			return template
		case .graphicCorner:
			guard let image = UIImage(named: "Graphic Corner") else {return nil}
			let template = CLKComplicationTemplateGraphicCircularImage(imageProvider:CLKFullColorImageProvider(fullColorImage: image))
			return template
		case .graphicCircular:
			guard let image = UIImage(named: "Graphic Circular") else {return nil}
			let template = CLKComplicationTemplateGraphicCircularImage(imageProvider:CLKFullColorImageProvider(fullColorImage: image))
			return template
		default:
			return nil
		}
	}
	
}
