//
//  SQLiteDatabase.swift
//  AugerTorque
//
//  Created by Manoj Belghaya on 28/10/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import Foundation

class SQLiteDatabase{
    
    let DB_NAME:String = "sph_db"
    let TABLE_NAME:String = "deck"
    let ID:String = "deck_id"
    let DECK_TYPE:String = "deck_type"
    let WORD:String = "word"
    let IS_PLAYED:String = "is_played"
    
    let databaseFileName = "/sahi_pakde_hain.db"
    
    var fileManager:FileManager? = nil
    var dirPath = Array<String>()
    var docDir:String
    var databasePath:String
    
    init() {
        fileManager = FileManager.default
        dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        docDir = dirPath[0]
        databasePath = docDir.appending(databaseFileName)
        createDatabase()
    }
    
    func createDatabase(){
        
        if !(fileManager?.fileExists(atPath: databasePath as String))! {
            
            let sphDatabase = FMDatabase(path: databasePath)
            
            if sphDatabase == nil {
                print("Error :\(sphDatabase?.lastErrorMessage())")
            }
            
            createTable()
        }
    }
    
    func reCreateTable() -> Bool{
        let resp:Bool
        if dropTable() {
            createTable()
            resp = true
        }else {
            resp = false
        }
        return resp
    }
    
    func createTable() {
        let database = FMDatabase(path: databasePath )
        if (database?.open())! {
            let query = "CREATE TABLE IF NOT EXISTS \(TABLE_NAME) (\(ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(DECK_TYPE) INTEGER, \(WORD) TEXT NOT NULL,\(IS_PLAYED) INTEGER);"
            
            if !(database?.executeStatements(query))! {
                print("Error:\(database?.lastErrorMessage())")
            }
            
            database?.close()
            
        }else {
            print("Error:\(database?.lastErrorMessage())")
        }

    }
    
    func dropTable() -> Bool{
        var isTableDroped = false
        let database = FMDatabase(path: databasePath )
        if (database?.open())! {
                let dropQuery = "DROP TABLE IF EXISTS \(TABLE_NAME);"
                
                let result = database?.executeUpdate(dropQuery, withArgumentsIn: nil)
                
                isTableDroped = result!
                print(" droped \(isTableDroped)")
            database?.close()
        }else {
            isTableDroped = false
        }
        return isTableDroped
    }
    
    func insertData(deckArray:Array<Deck>) -> Bool{
        var isInserted = false
        let database = FMDatabase(path: databasePath )
        if (database?.open())! {
            database?.beginTransaction()
            for deck in deckArray {
//                escaping single quote
                let encodedString = deck.word.replacingOccurrences(of: "'", with: "\"", options: .literal, range: nil)
                
                let insertQuery = "INSERT INTO \(TABLE_NAME)(\(DECK_TYPE),\(WORD),\(IS_PLAYED)) VALUES (\(deck.deckType),'\(encodedString)',0);"
                
                let result = database?.executeUpdate(insertQuery, withArgumentsIn: nil)
                
                isInserted = result!
                print(isInserted)
            }
            database?.commit()
            database?.close()
        }
        return isInserted
    }
    
    func getSelectedDeckData(categoryId:Int) -> Array<Deck> {
        var deckArray:Array<Deck>
        deckArray = getDecklist(categoryId: categoryId)
        if deckArray.count > 25 {
            return deckArray
        }else {
            updateAllDeckIsPlayed(deckType: categoryId)
            deckArray = getDecklist(categoryId: categoryId)
            return deckArray
        }
    }
    
    func updateAllDeckIsPlayed(deckType:Int) {
        let database = FMDatabase(path:databasePath)
        if (database?.open())!{
            let query = "UPDATE \(TABLE_NAME) SET \(IS_PLAYED) = 0 WHERE \(DECK_TYPE) = \(deckType)";
            let result = database?.executeQuery(query, withArgumentsIn: nil)
            database?.close()
        }
    }
    
    func updateDeckIsPlayed(deckResultArray:Array<DeckResult>) {
        let database = FMDatabase(path:databasePath)
        if (database?.open())!{
            if !deckResultArray.isEmpty && deckResultArray.count > 0{
                for deck in deckResultArray {
                    let query = "UPDATE \(TABLE_NAME) SET \(IS_PLAYED) = 1 WHERE \(ID) = \(deck.deckId)";
                    _ = database?.executeQuery(query, withArgumentsIn: nil)
                }
            }
            database?.close()
        }
    }

    func getDecklist(categoryId:Int) -> Array<Deck> {
        var deckArray = Array<Deck>()
        let database = FMDatabase(path:databasePath)
        if (database?.open())!{
            let query = "SELECT * FROM \(TABLE_NAME) WHERE \(DECK_TYPE) = \(categoryId) AND \(IS_PLAYED) = 0 ORDER BY RANDOM()";
            
            let result = database?.executeQuery(query, withArgumentsIn: nil)
            
            if result != nil {
                while (result?.next())! {
                    let deckId = (result?.int(forColumn: ID))!
                    let deckType = (result?.int(forColumn: DECK_TYPE))!
                    let word = (result?.string(forColumn: WORD))!.replacingOccurrences(of: "\"", with: "'", options: String.CompareOptions.literal, range: nil)
                    
                    let deck = Deck(deckId: Int(deckId), deckType: Int(deckType), word: word)
                    
                    deckArray.append(deck)
                    //
                }
            }
            database?.close()
        }
        return deckArray
    }
    
}
