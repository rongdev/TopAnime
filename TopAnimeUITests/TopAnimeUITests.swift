//
//  TopAnimeUITests.swift
//  TopAnimeUITests
//
//  Created by 1300328 on 2022/5/20.
//

import XCTest

class TopAnimeUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadMore() throws {
        let app = XCUIApplication()
        app.launch()
        
        sleep(1)
        app.tapPicker("txfAnimeType", val: "special")
        app.tapPicker("txfAnimeFilter", val: "airing")
        sleep(1)
        app.scrollView("cvAnime", times: 5)
        
        app.navigationBars["TopAnime.TAAnimeView"].buttons["Manga"].tap()
        app.tapPicker("txfMangaType", val: "manga")
        app.tapPicker("txfMangaFilter", val: "upcoming")
        sleep(1)
        app.scrollView("cvManga", times: 8)
    
        sleep(5)
    }
    
    func testAddOrRemoveFavorite() throws {
        let app = XCUIApplication()
        app.launch()
        
        // AddFavorite - Anime
        sleep(2)
        app.addOrRemoveFav("cvAnime", idx: 0)
        app.addOrRemoveFav("cvAnime", idx: 0)
        app.addFavAndScroll("cvAnime")
        app.addFavAndScroll("cvAnime")
        app.scrollView("cvAnime", times: 2, swipeUp: false)
        
        // AddFavorite - Manga
        sleep(1)
        app.navigationBars["TopAnime.TAAnimeView"].buttons["Manga"].tap()
        app.addFavAndScroll("cvManga")
        app.addFavAndScroll("cvManga")
        app.scrollView("cvManga", times: 2, swipeUp: false)
        
        // My Favorite - Delete Favorite
        sleep(1)
        app.tabBars["Tab Bar"].buttons["My Favorites"].tap()
        
        sleep(2)
        app.addOrRemoveFav("cvFavorite", idx: 0)
        app.addOrRemoveFav("cvFavorite", idx: 0)
        app.addOrRemoveFav("cvFavorite", idx: 0)

        sleep(2)
        app.buttons["Manga"].tap()
        app.addOrRemoveFav("cvFavorite", idx: 0)
        app.addOrRemoveFav("cvFavorite", idx: 0)
        app.addOrRemoveFav("cvFavorite", idx: 0)
        
        // Home - Sync Deleted Favorite
        sleep(1)
        app.tabBars["Tab Bar"].buttons["Home"].tap()
        
        sleep(1)
        app.scrollView("cvManga")
        
        sleep(1)
        app.navigationBars["TopAnime.TAAnimeView"].buttons["Anime"].tap()
        
        sleep(1)
        app.scrollView("cvAnime")
        
        sleep(5)
    }
    
    func testTapItem() throws {
        let app = XCUIApplication()
        app.launch()
    
        // Anime
        sleep(1)
        app.collectionViews["cvAnime"].children(matching: .cell).element(boundBy: 0).tap()
        app.tapCoordinate()
        
        // Manga
        sleep(1)
        app.navigationBars["TopAnime.TAAnimeView"].buttons["Manga"].tap()
        app.collectionViews["cvManga"].children(matching: .cell).element(boundBy: 0).tap()
        app.tapCoordinate()
        
        sleep(1)
        app.tabBars["Tab Bar"].buttons["My Favorites"].tap()
        sleep(1)
        app.collectionViews["cvFavorite"].children(matching: .cell).element(boundBy: 0).tap()
        
        sleep(5)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCUIApplication {
    func tapCoordinate(at point: CGPoint = CGPoint(x: 20, y: 50)) {
        let normalized = coordinate(withNormalizedOffset: .zero)
        let offset = CGVector(dx: point.x, dy: point.y)
        let coordinate = normalized.withOffset(offset)
        
        sleep(3)
        coordinate.tap()
    }
    
    func tapPicker(_ name: String, val: String) {
        let element = textFields[name]
        
        if element.exists {
            textFields[name].tap()
            pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: val)
            toolbars["Toolbar"].buttons["Done"].tap()
        }
    }
    
    func addFavAndScroll(_ name: String, idx: Int = 0) {
        addOrRemoveFav(name, idx: idx)
        addOrRemoveFav(name, idx: idx + 1)
        addOrRemoveFav(name, idx: idx + 2)
        scrollView(name)
    }
    
    func addOrRemoveFav(_ name: String, idx: Int) {
        let favOff = collectionViews[name]
            .children(matching: .cell)
            .element(boundBy: idx).buttons["Add Favorite"]
        let favOn = collectionViews[name]
            .children(matching: .cell)
            .element(boundBy: idx).buttons["Remove Favorite"]
    
        if favOn.exists { favOn.tap() }
        else if favOff.exists { favOff.tap() }
    }
    
    func scrollView(_ name: String, swipeUp: Bool = true) {
        let element = collectionViews[name]
            .children(matching: .cell).element(boundBy: 2)
            .children(matching: .other).element
            .children(matching: .other).element
        
        if element.exists {
            if swipeUp { element.swipeUp() }
            else { element.swipeDown() }
        }
    }
    
    func scrollView(_ name: String, times: Int, swipeUp: Bool = true) {
        var x = 0
        while x < times {
            if swipeUp { scrollView(name, swipeUp: true) }
            else { scrollView(name, swipeUp: false) }
            
            x+=1
        }
    }
}

