//
//  teamPlayUtil.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 24/02/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import Foundation

class TeamPlayUtil {
    
    static var isTeamPlay = false
    
    static var totalTeams = 2
    static var totalRounds = 3
    
    static var playingTeam = 0
    static var playingRound = 0
    
    static var totalTeamScore:Array<Int> = []
    static var team1Score:Array<Int> = []
    static var team2Score:Array<Int> = []
    
    static func setIsTeamPlay(isTeamPlay:Bool) {
        TeamPlayUtil.isTeamPlay = isTeamPlay
    }

    static func setTotalRounds(round:Int) {
        TeamPlayUtil.totalRounds = round
    }
    
    static func setPlayingTeam(team:Int) {
        TeamPlayUtil.playingTeam = team
    }
    
    static func playingRound(playingRound:Int) {
        TeamPlayUtil.playingRound = playingRound
    }
    
    static func setTotalTeamScore(teamScore:Array<Int>){
        TeamPlayUtil.totalTeamScore = teamScore
    }
    
    static func setTeam1Score(team1Score:Array<Int>){
        TeamPlayUtil.team1Score = team1Score
    }

    static func setTeam2Score(team2Score:Array<Int>){
        TeamPlayUtil.team2Score = team2Score
    }
    
}
