//
//  CheckWordViewController.swift
//  Flashcard
//
//  Created by 原直輝 on 2021/11/13.
//

import UIKit

class CheckWordViewController: UIViewController {
    @IBOutlet weak var wordNumberLabel: UILabel! // 問題番号の表示
    @IBOutlet weak var wordsView: UIButton! // 単語表示ボタン
    @IBOutlet weak var slider: UISlider! // スライダー
    
    var whethermark: [Int] = [] // 単語にマークがつけているかどうか，前の画面からの情報を取得
    var csvArray: [String] = [] // 問題データを入れる配列
    var csvArray2: [String] = [] // 前の画面でチェックをつけた番号の単語を入れる配列
    var checkwordsArray: [String] = [] // 配列csvArrayから1つずつ抽出した要素を入れる配列
    var wordsCount = 0 // csvArrayの要素の番号(単語番号): 0〜(全単語数)-1
    var language = 1 // 0: 日本語意味, 1: 英語意味
    
    
    // 前画面(設定画面)からの実験種類と学習回数の値を取得
    var kind:String = ""
    var material:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 前画面から取得した値を元に場合分けし、表示するcsvファイルを変える
        // 関数loadCSVの処理によって指定された名前のcsvファイルを配列に変換し、配列csvArrayに代入
        if(kind=="A" && material==1){
            csvArray = loadCSV(fileName: "wordsA1")
        }else if(kind=="A" && material==2){
            csvArray = loadCSV(fileName: "wordsA2")
        }else if(kind=="A" && material==3){
            csvArray = loadCSV(fileName: "wordsA3")
        }else if(kind=="A" && material==4){
            csvArray = loadCSV(fileName: "wordsA4")
        }else if(kind=="B" && material==1){
            csvArray = loadCSV(fileName: "wordsB1")
        }else if(kind=="B" && material==2){
            csvArray = loadCSV(fileName: "wordsB2")
        }else if(kind=="B" && material==3){
            csvArray = loadCSV(fileName: "wordsB3")
        }else if(kind=="B" && material==4){
            csvArray = loadCSV(fileName: "wordsB4")
        }else{
            print("エラー")
        }
        
        
        // 関数loadCSVの処理によってwordsという名のcsvファイルを配列に変換し、配列csvArrayに代入
        //csvArray = loadCSV(fileName: "words")
        
        // csvArray2に特定の問題データを格納
        for wordsCount in 0..<csvArray.count {
            if(whethermark[wordsCount]==1) {
                csvArray2.append(csvArray[wordsCount])
            }
        }
        
        // 配列csvArray2のwordsCount行目をカンマ区切りで配列checkwordsArrayに入れている(whethermarkが1の単語のみ)
        checkwordsArray = csvArray2[wordsCount].components(separatedBy: ",")
        
        wordNumberLabel.text = "\(wordsCount+1) / \(csvArray2.count)" // 単語番号の表示
        wordsView.setTitle(checkwordsArray[language], for: .normal)
        
        slider.value = 0
        slider.maximumValue = Float(csvArray2.count) - 1
        slider.minimumValue = 0
        
        
        // Do any additional setup after loading the view.
    }
    
    
    // 単語表示ボタンを押した際の処理，押すと表示言語が切り替わる
    @IBAction func wordsView(_ sender: Any) {
        if(language==0) {
            language = 1
        } else if(language==1) {
            language = 0
        }
        wordsView.setTitle(checkwordsArray[language], for: .normal)
    }
    
    
    @IBAction func slider(_ sender: UISlider) {
        wordsCount = Int((sender.value))
        checkwordsArray = csvArray2[wordsCount].components(separatedBy: ",")
        wordNumberLabel.text = "\(wordsCount+1) / \(csvArray2.count)"
        wordsView.setTitle(checkwordsArray[language], for: .normal)
    }
    
    
    // 次の単語へ進む処理
    @IBAction func nextWords(_ sender: Any) {
        nextWords()
    }
    
    // 前の単語へ戻る処理
    @IBAction func backWords(_ sender: Any) {
        backWords()
    }
    
    
    // 前の画面に戻る処理
    @IBAction func beforeScreenAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
    // 次の単語をセットする処理
    func nextWords() {
        wordsCount += 1
        slider.value = Float(wordsCount) // ボタンを押すたびにスライダーを右に移動
        if(0<=wordsCount && wordsCount<csvArray2.count) {
            checkwordsArray = csvArray2[wordsCount].components(separatedBy: ",")
            wordNumberLabel.text = "\(wordsCount+1) / \(csvArray2.count)"
            wordsView.setTitle(checkwordsArray[language], for: .normal)
        } else if(wordsCount>=csvArray2.count) {
            wordsCount = csvArray2.count - 1
        }
    }
    
    
    // 前の単語をセットする処理
    func backWords() {
        if(0<wordsCount && wordsCount<=csvArray2.count) {
            wordsCount -= 1
            slider.value = Float(wordsCount) // ボタンを押すたびにスライダーを左に移動
            checkwordsArray = csvArray2[wordsCount].components(separatedBy: ",")
            wordNumberLabel.text = "\(wordsCount+1) / \(csvArray2.count)"
            wordsView.setTitle(checkwordsArray[language], for: .normal)
        }
    }
    
    
    // csvファイルを読み込んで配列に変換するプログラム
    func loadCSV(fileName: String) -> [String] {
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8)
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        } catch {
            print("error!")
        }
        return csvArray
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
