//
//  JournalDBManager.swift
//  MyJournal
//
//  Created by Josh Gerlach on 28/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import Foundation

/**
 Struct to Handle all of the Database functionality
 Handles all conversion from Journal object to JournalDB and back again
 **/
struct JournalDBManager: JournalManagerProtocol {
    
    //Database path where the db file is located, loaded at every call to ensure no errors
    fileprivate var databasePath = NSString()
    //Name of the journal database file
    fileprivate let filename:String = "myjournal.db"
    //Name of the Table that is being used in the databse
    fileprivate let tableName:String = "JOURNALS"
    
    /**
     Conveinience function that ensures that the database path is set correctly
     Called at the start of every database function in this struct to ensure no errors, mostly in testing
     **/
    fileprivate mutating func setDatabasePath(){
        
        //Get all directories in document path
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        //The first path contians the database file
        let docsDir = dirPaths[0]
        
        //Set the database path
        databasePath = (docsDir as NSString).appendingPathComponent(
            filename) as NSString
    }
    
    /**
     Initialse the database
     This includes creating the database file, creating the table/s and loading the default data
     **/
    mutating func initialiseDatabase()->Bool
    {
        //Ensure the database path is set
        setDatabasePath()
        
        // Create the database
        let filemgr = FileManager.default
        
        //Check if the databse file exists
        if !filemgr.fileExists(atPath: databasePath as String)
        {
            // Get a reference to the database
            let journalDB = FMDatabase(path: databasePath as String)
            
            //If the reference failed, print error and return false
            if journalDB == nil {
                print("Error: \(journalDB?.lastErrorMessage())")
                return false
            }
            
            // Open the database
            if (journalDB?.open())!
            {
                
                // Prepare a statement for operating on the database
                let sql_stmt = "CREATE TABLE " + tableName + " (ID INTEGER PRIMARY KEY AUTOINCREMENT, TIMESTAMP TEXT, NOTE TEXT, MUSIC TEXT, QUOTE TEXT, PHOTO TEXT, WEATHER TEXT, MOOD TEXT, DATE TEXT, LOCATION STRING, FAVOURITE INTEGER, COORDINATES TEXT, RECORDNAME TEXT, VIDEOURL TEXT, UNIQUE(TIMESTAMP))"
                
                // Execute the statement
                if !(journalDB?.executeStatements(sql_stmt))! {
                    //If there was an error, print error, close the databse and return false
                    print("Error: \(journalDB?.lastErrorMessage())")
                    journalDB?.close()
                    return false
                }else {
                    //if it was created, print message
                    print("Journals Database created")
                }
                
                // Close the database
                journalDB?.close()
                
                //Insert new Journal entries into Database after creation
                for journalIndexPair in FakeJournalEntries.getFakeJournalEntries()
                {
                    //If at any point there is an error inserting the default values,
                    //Return false right away as it cant be trusted
                    if !addJournal(journal: journalIndexPair.value)
                    {
                        return false
                    }
                }
                
                //If all went well, return true
                return true
                
            } else {
                //Otherwise if file/databse could not be created print error message and return false
                print("Error: \(journalDB?.lastErrorMessage())")
                return false
            }
        }
        //Return true by default, not good practice but time is not our friend
        return true
    }
    
    /**
     Function to drop the Journals table and delete the file
     Mostly for testing but might be good if a user wanted to "start again", not implimented at this stage
     Returns status of delete in the form of a boolean
     **/
    mutating func removeDatabaseFile()->Bool
    {
        //Ensure the database path is set
        setDatabasePath()
        
        // Create the database
        let filemgr = FileManager.default
        
        //Check if the file exists
        if filemgr.fileExists(atPath: databasePath as String)
        {
            // Get a reference to the database
            let journalDB = FMDatabase(path: databasePath as String)
            
            //If there is no reference the print message and return false
            if journalDB == nil {
                print("Error: \(journalDB?.lastErrorMessage())")
                return false
            }
            
            // Open the database
            if (journalDB?.open())!
            {
                
                // Prepare a drop statement of the table
                let sql_stmt = "DROP TABLE " + tableName
                
                // Execute the statement
                if !(journalDB?.executeStatements(sql_stmt))! {
                    print("Error: \(journalDB?.lastErrorMessage())")
                }else {
                    //Otherwise, YAY it worked
                    print("Journals Database Dropped")
                }
                
                // Close the database
                journalDB?.close()
                
                
            } else {
                //If the database is unable to be opened then print message and return false
                print("Error: \(journalDB?.lastErrorMessage())")
                return false
            }
        }
        
        do{
            //Try to delete the database file, if it succeeded return true, otherwise return false
            try filemgr.removeItem(atPath: databasePath as String)
            return true
        }catch {
            return false
        }
        
    }
    
    /**
     Save a Journal Entry into the Database
     Return boolean to indicate success of insertion, false by default, that is just good practice :P
     **/
    mutating func addJournal(journal: Journal) -> Bool {
        //Ensure the database path is set
        setDatabasePath()
        
        //Convert Journal entry into JournalDB object ready for insertion into DB
        let journalDBEntry:JournalDB = JournalDatabaseAdapter.convertForDatabase(journal: journal)
        
        // Get a reference to the database
        let journalDB = FMDatabase(path: databasePath as String)
        
        //Open the database
        if (journalDB?.open())!
        {
            // Prepare a statement for operating on the database
            let insertSQL = "INSERT INTO " + tableName + " (timestamp, note, music, quote, photo, weather, mood, date, location, favourite, coordinates, recordname, videourl) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
            
            // Execute the update statement
            do{
                try journalDB?.executeUpdate(insertSQL, values: [journalDBEntry.id, journalDBEntry.note, journalDBEntry.music, journalDBEntry.quote, journalDBEntry.photo, journalDBEntry.weather, journalDBEntry.mood, journalDBEntry.date, journalDBEntry.location, journalDBEntry.favorite, journalDBEntry.coordinates, journalDBEntry.recordName, journalDBEntry.videoURL])
                
                //Print successful result
                print("Journal Entry Added")
                // Close the database
                journalDB?.close()
                return true
            }catch {
                //If there was an error inserting into DB, print error, close the DB and return false
                print("Failed to add Journal Entry \(journalDB?.lastErrorMessage())")
                // Close the database
                journalDB?.close()
                return false
            }
            
            
            
        } else {
            //If there was a failure to open the database file, print message
            print("Error: \(journalDB?.lastErrorMessage())")
        }
        //Return false by default
        return false
    }
    
    /**
     Function to take a single Database row, represented as a FMResultSet, pull the data out and convert to a Journal Entry
     Returns a Journal Entry if Database row is not nil
    **/
    fileprivate func extractDataFromDatabaseRow(resultSet: FMResultSet?)-> Journal?
    {
        //Check if result set is nil before performing data extraction
        if resultSet == nil {
            return nil
        }
        
        //Load values from database into a JournalDB object
        var journalFromDatabase:JournalDB = JournalDB()
        journalFromDatabase.id = resultSet!.string(forColumn: "timestamp")
        journalFromDatabase.note = resultSet!.string(forColumn: "note")
        journalFromDatabase.date = resultSet!.string(forColumn: "date")
        journalFromDatabase.coordinates = resultSet!.string(forColumn: "coordinates")
        journalFromDatabase.location = resultSet!.string(forColumn: "location")
        journalFromDatabase.mood = resultSet!.string(forColumn: "mood")
        journalFromDatabase.music = resultSet!.string(forColumn: "music")
        journalFromDatabase.weather = resultSet!.string(forColumn: "weather")
        journalFromDatabase.photo = resultSet!.string(forColumn: "photo")
        journalFromDatabase.quote = resultSet!.string(forColumn: "quote")
        journalFromDatabase.favorite = Int(resultSet!.int(forColumn: "favourite"))
        journalFromDatabase.recordName = resultSet!.string(forColumn: "recordname")
        journalFromDatabase.videoURL = resultSet!.string(forColumn: "videourl")
        
        //Convert from JournalDB object to a Journal object
        return JournalDatabaseAdapter.convertFromDatabase(journalDB: journalFromDatabase)
    }
    
    /**
     Get all Journal Entries from database and return as a Dictionary
     Return Dictionary of results if found, nil if nothing or error
     **/
    mutating func getAllJournalEntries()->[String: Journal]?
    {
        //Ensure the database path is set
        setDatabasePath()
        
        // Get a reference to the database
        let journalDB = FMDatabase(path: databasePath as String)
        
        //Open the databse
        if (journalDB?.open())!
        {
            // Prepare a statement for operating on the database
            let querySQL = "SELECT * FROM " + tableName
            
            //If the table does not exist, print error and return nil
            if !(journalDB?.tableExists(tableName))!{
                print("Table not found: " + tableName)
                return nil
            }
            
            //Execute the query
            let resultSet:FMResultSet? = journalDB?.executeQuery(querySQL,withArgumentsIn: nil)
            
            //If there are no results or an error, print an error, close the database and return nil
            if resultSet == nil {
                print("Failed to get Journal Entries")
                // Close the database
                journalDB?.close()
                return nil
            }else {
                //Otherwise, loop through all the results and add to the the Dictionary to be returned
                var journalEntries:[String: Journal] = [:]
                
                while (resultSet?.next())! {
                    //Load values from database into a JournalDB object
                    var journalFromDatabase:JournalDB = JournalDB()
                    journalFromDatabase.id = resultSet!.string(forColumn: "timestamp")
                    journalFromDatabase.note = resultSet!.string(forColumn: "note")
                    journalFromDatabase.date = resultSet!.string(forColumn: "date")
                    journalFromDatabase.coordinates = resultSet!.string(forColumn: "coordinates")
                    journalFromDatabase.location = resultSet!.string(forColumn: "location")
                    journalFromDatabase.mood = resultSet!.string(forColumn: "mood")
                    journalFromDatabase.music = resultSet!.string(forColumn: "music")
                    journalFromDatabase.weather = resultSet!.string(forColumn: "weather")
                    journalFromDatabase.photo = resultSet!.string(forColumn: "photo")
                    journalFromDatabase.quote = resultSet!.string(forColumn: "quote")
                    journalFromDatabase.favorite = Int(resultSet!.int(forColumn: "favourite"))
                    journalFromDatabase.recordName = resultSet!.string(forColumn: "recordname")
                    journalFromDatabase.videoURL = resultSet!.string(forColumn: "videourl")
                    
                    //Convert from JournalDB object to a Journal object
                    let journal:Journal? = JournalDatabaseAdapter.convertFromDatabase(journalDB: journalFromDatabase)
                    
                    //If the conversion was successful, add to the Dictionary to be returned
                    if journal != nil {
                        journalEntries[(journal?.id)!] = journal
                    }
                    
                    
                }
                
                // Close the database
                journalDB?.close()
                //Return the stoked up Dictionary
                return journalEntries
            }
            
        } else {
            //If there was an error opening the database, print the message
            print("Error: \(journalDB?.lastErrorMessage())")
        }
        //Return nil by default
        return nil
    }
    
    /**
     Get a Journal from the database and return as a Journal object
     Returns found Journal object or nil if not found or on error
     **/
    mutating func getJournalEntryByKey(key: String) -> Journal? {
        //Ensure the database path is set
        setDatabasePath()
        
        // Get a reference to the database
        let journalDB = FMDatabase(path: databasePath as String)
        
        //Open the database
        if (journalDB?.open())!
        {
            // Prepare a statement for operating on the database
            let querySQL = "SELECT * FROM " + tableName + " WHERE TIMESTAMP='\(key)'"
            
            //Execute the query
            let resultSet:FMResultSet? = journalDB?.executeQuery(querySQL,
                                                                 withArgumentsIn: nil)
            //If the result is nil, return nil and print an error
            if resultSet == nil {
                print("Failed to get Journal Entry")
                // Close the database
                journalDB?.close()
                return nil
            }else {
                //If there is at least one result, get the first one and load into JournalDB for conversion
                if (resultSet?.next())! {
                    var journalFromDatabase:JournalDB = JournalDB()
                    journalFromDatabase.id = resultSet!.string(forColumn: "timestamp")
                    journalFromDatabase.note = resultSet!.string(forColumn: "note")
                    journalFromDatabase.date = resultSet!.string(forColumn: "date")
                    journalFromDatabase.coordinates = resultSet!.string(forColumn: "coordinates")
                    journalFromDatabase.location = resultSet!.string(forColumn: "location")
                    journalFromDatabase.mood = resultSet!.string(forColumn: "mood")
                    journalFromDatabase.music = resultSet!.string(forColumn: "music")
                    journalFromDatabase.weather = resultSet!.string(forColumn: "weather")
                    journalFromDatabase.photo = resultSet!.string(forColumn: "photo")
                    journalFromDatabase.quote = resultSet!.string(forColumn: "quote")
                    journalFromDatabase.favorite = Int(resultSet!.int(forColumn: "favourite"))
                    journalFromDatabase.recordName = resultSet!.string(forColumn: "recordname")
                    journalFromDatabase.videoURL = resultSet!.string(forColumn: "videourl")
                    
                    //Convert the JournalDB into a Journal object
                    let journal:Journal? = JournalDatabaseAdapter.convertFromDatabase(journalDB: journalFromDatabase)
                    
                    //Test if the converted Journal is nil, print an error if so
                    if journal != nil {
                        print("Journal Entry Retrieved")
                    }
                    
                    // Close the database
                    journalDB?.close()
                    
                    //Return the journal
                    return journal
                }else {
                    //if there was no result, print error, close DB and return nil
                    print("Failed to get Journal Entry :( \(journalDB?.lastErrorMessage())")
                    // Close the database
                    journalDB?.close()
                    return nil
                }
                
            }
            
        } else {
            //If the file failed to open print message
            print("Error: \(journalDB?.lastErrorMessage())")
        }
        //Return nil by default
        return nil
    }
    
    /**
     Update all the values of a Journal that already exists in the database by id (timestamp in the database)
     Return a boolean indicating whether or not the update was successful
     **/
    mutating func updateJournalyEntry(journal: Journal) -> Bool {
        //Ensure the database path is set
        setDatabasePath()
        
        
        //Convert Journal Entry into Database ready Journal Entry
        let journalDBEntry:JournalDB = JournalDatabaseAdapter.convertForDatabase(journal: journal)
        
        // Get a reference to the database
        let journalDB = FMDatabase(path: databasePath as String)
        
        //Open the database
        if (journalDB?.open())!
        {
            //Convert the Journal Entry favourite into an Int for the databse
            // Prepare a statement for operating on the database
            let updateFavSQL = "UPDATE " + tableName + " SET " +
                "note = ?, " +
                "music = ?, " +
                "quote = ?, " +
                "photo = ?, " +
                "weather = ?, " +
                "mood = ?, " +
                "date = ?, " +
                "location = ?, " +
                "favourite = ?, " +
                "coordinates = ?, " +
                "videourl = ?, " +
                "recordname = ? " +
            "WHERE TIMESTAMP= ?"
            
            do{
                //Update the database with the changed value
                try journalDB?.executeUpdate(updateFavSQL, values:
                    [journalDBEntry.note,
                     journalDBEntry.music,
                     journalDBEntry.quote,
                     journalDBEntry.photo,
                     journalDBEntry.weather,
                     journalDBEntry.mood,
                     journalDBEntry.date,
                     journalDBEntry.location,
                     journalDBEntry.favorite,
                     journalDBEntry.coordinates,
                     journalDBEntry.videoURL,
                     journalDBEntry.recordName,
                     journalDBEntry.id]
                )
                
                //If successful, print result
                print("Journal Entry Updated")
                // Close the database
                journalDB?.close()
                //Tell caller that update was successful
                return true
                
            }catch {
                //If there was an error, print it, close the database and return false
                print("Failed to update Journal Entry")
                // Close the database
                journalDB?.close()
                return false
            }
            
        } else {
            //If there was an error opening the database, print error message
            print("Error: \(journalDB?.lastErrorMessage())")
        }
        //Return false by default
        return false
    }
    
    
    /**
     Function to update a change favourite state of a Journal entry into the databse
     Returns success status of update as a boolean
     **/
    mutating func toggleJournalFavouriteByKey(key: String) -> Bool {
        
        //Ensure the database path is set
        setDatabasePath()
        
        //Get Journal Entry from Database
        var journalEntry:Journal? = getJournalEntryByKey(key: key)
        
        //Test that the Journal Entry is not nil
        if journalEntry == nil {
            return false
        }
        
        //Flip the value of the Journal Entry Favourite
        journalEntry!.favorite = !journalEntry!.favorite
        
        // Get a reference to the database
        let journalDB = FMDatabase(path: databasePath as String)
        
        //Open the database
        if (journalDB?.open())!
        {
            //Convert the Journal Entry favourite into an Int for the databse
            let favouriteValue:Int = JournalDatabaseAdapter.convertFavourite(favorite: journalEntry!.favorite)
            // Prepare a statement for operating on the database
            let updateFavSQL = "UPDATE " + tableName + " SET favourite = ? WHERE TIMESTAMP= ?"
            
            do{
                //Update the database with the changed value
                try journalDB?.executeUpdate(updateFavSQL, values: [favouriteValue, key])
                
                //If successful, print result
                print("Journal Entry Updated")
                // Close the database
                journalDB?.close()
                //Tell caller that update was successful
                return true
                
            }catch {
                //If there was an error, print it, close the database and return false
                print("Failed to update Journal Entry")
                // Close the database
                journalDB?.close()
                return false
            }
            
        } else {
            //If there was an error opening the database, print error message
            print("Error: \(journalDB?.lastErrorMessage())")
        }
        //Return false by default
        return false
    }
    
    /**
     Function to delete a Journal entry (by timestamp, ID in Model) from the database
     Return the successfulness of the deletion as a boolean
     **/
    mutating func deleteJournalEntryByKey(key: String) -> Bool {
        
        //Ensure the database path is set
        setDatabasePath()
        
        // Get a reference to the database
        let journalDB = FMDatabase(path: databasePath as String)
        
        //Open the database
        if (journalDB?.open())!
        {
            // Prepare a statement for operating on the database
            let deleteSQL = "DELETE from " + tableName + " WHERE TIMESTAMP='\(key)'"
            
            // Execute the update statement
            let result = journalDB?.executeUpdate(deleteSQL, withArgumentsIn: nil)
            
            //If the deletion failed, print error, close the database and return false
            if !result! {
                print("Failed to remove Journal Entry")
                // Close the database
                journalDB?.close()
                return false
            }else {
                //If the Journal was removed from the database, print message, close database and return true
                print("Journal Entry Removed")
                // Close the database
                journalDB?.close()
                return true
            }
            
        } else {
            //If database could not be opened, print an error message
            print("Error: \(journalDB?.lastErrorMessage())")
        }
        //Return false by default
        return false
    }
    
    
    
}
