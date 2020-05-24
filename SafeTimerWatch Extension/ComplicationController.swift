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
            let template = CLKComplicationTemplateExtraLargeSimpleImage()
            guard let image = UIImage(named: "Modular") else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            handler(template)
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallSquare()
            guard let image = UIImage(named: "Utilitarian") else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            handler(template)
        case .circularSmall:
            let template = CLKComplicationTemplateExtraLargeSimpleImage()
            guard let image = UIImage(named: "Circular") else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            handler(template)
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeSimpleImage()
            guard let image = UIImage(named: "Extra Large") else { handler(nil); return}
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            handler(template)
        case .graphicCorner:
            let template = CLKComplicationTemplateGraphicCircularImage()
            guard let image = UIImage(named: "Graphic Corner") else { handler(nil); return}
            template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
            handler(template)
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularImage()
            guard let image = UIImage(named: "Graphic Circular") else { handler(nil); return}
            template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
            handler(template)
        default:
            handler(nil)
        }
    }
 
    func getComplicationTemplate(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {
          switch(complication.family) {
          case .modularSmall:
              let template = CLKComplicationTemplateExtraLargeSimpleImage()
              guard let image = UIImage(named: "Modular") else {return nil}
              template.imageProvider = CLKImageProvider(onePieceImage: image)
              return template
          case .utilitarianSmall:
              let template = CLKComplicationTemplateUtilitarianSmallSquare()
              guard let image = UIImage(named: "Utilitarian") else {return nil}
              template.imageProvider = CLKImageProvider(onePieceImage: image)
              return template
          case .circularSmall:
              let template = CLKComplicationTemplateExtraLargeSimpleImage()
              guard let image = UIImage(named: "Circular") else {return nil}
              template.imageProvider = CLKImageProvider(onePieceImage: image)
              return template
          case .extraLarge:
              let template = CLKComplicationTemplateExtraLargeSimpleImage()
              guard let image = UIImage(named: "Extra Large") else {return nil}
              template.imageProvider = CLKImageProvider(onePieceImage: image)
              return template
          case .graphicCorner:
              let template = CLKComplicationTemplateGraphicCircularImage()
              guard let image = UIImage(named: "Graphic Corner") else {return nil}
              template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
              return template
          case .graphicCircular:
              let template = CLKComplicationTemplateGraphicCircularImage()
              guard let image = UIImage(named: "Graphic Circular") else {return nil}
              template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
              return template
          default:
              return nil
          }
      }
    
}
