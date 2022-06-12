//
//  WordViewController.swift
//  Flashcard
//
//  Created by 原直輝 on 2021/11/09.
//

import UIKit

class WordViewController: UIViewController {
    @IBOutlet weak var wordNumberLabel: UILabel! // 問題番号の表示
    @IBOutlet weak var wordsView: UIButton! // 単語表示ボタン
    @IBOutlet weak var slider: UISlider! // スライダー
    @IBOutlet weak var check: UIButton! // ☆ボタン
    @IBOutlet weak var moveCheckwords: UIButton! // 「☆単語へ」のボタン
    
    
    var csvArray: [String] = [] // 問題データを入れる配列
    var wordsArray: [String] = [] // 配列csvArrayから1つずつ抽出した要素を入れる配列
    var wordsCount = 0 // csvArrayの要素の番号(単語番号): 0〜(全単語数-1)
    var language = 1 // 0: 日本語意味, 1: 英語意味

    // checkbuttonColorは色の様子を表す配列 (この0,1の値を変更することでボタンの色を変える),  0:白, 1:黄色
    var checkbuttonColor: [Int] = []
    
    
    
    // 前画面(設定画面)からの実験種類と学習回数の値を取得
    var kind:String = ""
    var material:Int = 0
    
    
    // 画面を呼び出した際に実行される処理
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
        
        // 配列csvArrayのwordsCount行目をカンマ区切りで配列wordsArrayに入れている
        wordsArray = csvArray[wordsCount].components(separatedBy: ",")
        
        wordNumberLabel.text = "\(wordsCount+1) / \(csvArray.count)" // 単語番号の表示
        wordsView.setTitle(wordsArray[language], for: .normal) // 単語の表示
        
        slider.value = 0 // スライダーの位置を左端に(サンプル)
        slider.maximumValue = Float(csvArray.count) - 1 // スライダーの最大値を設定
        slider.minimumValue = 0 // スライダーの最小値を設定
        
        // 全部を0に設定 (全部を白にする)
        checkbuttonColor = Array(repeating: 0, count: csvArray.count)
        
        // マーク付きの単語がなければ「☆単語へ」のボタンを無効化
        moveCheckwords.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    
    // 単語表示ボタンを押した際の処理，押すと表示言語が切り替わる
    @IBAction func wordsView(_ sender: Any) {
        if(language == 0) {
            language = 1
        } else if(language == 1) {
            language = 0
        }
        wordsView.setTitle(wordsArray[language], for: .normal)
    }
    
    
    // スライダーの処理
    @IBAction func slider(_ sender: UISlider) {
        wordsCount = Int((sender.value))
        wordsArray = csvArray[wordsCount].components(separatedBy: ",")
        wordNumberLabel.text = "\(wordsCount+1) / \(csvArray.count)"
        wordsView.setTitle(wordsArray[language], for: .normal)
        
        // 配列checkbuttonColorの値によってボタンの色を設定
        if(checkbuttonColor[wordsCount]==0) {
            check.backgroundColor = UIColor.white
        } else {
            check.backgroundColor = UIColor.systemYellow
        }
    }
    
    
    // 次の単語へ進む処理
    @IBAction func nextWords(_ sender: Any) {
        nextWords()
    }
    
    
    // 前の単語へ戻る処理
    @IBAction func backWords(_ sender: Any) {
        backWords()
    }
    
    
    // 学習をやめる処理(前の画面に戻る処理)
    @IBAction func stopLearningAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    
    // 次の単語をセットする処理
    func nextWords() {
        wordsCount += 1
        slider.value = Float(wordsCount) // ボタンを押すたびにスライダーを右に移動
        
        if(0<=wordsCount && wordsCount<csvArray.count) {
            wordsArray = csvArray[wordsCount].components(separatedBy: ",")
            wordNumberLabel.text = "\(wordsCount+1) / \(csvArray.count)"
            wordsView.setTitle(wordsArray[language], for: .normal)
            
            if(checkbuttonColor[wordsCount]==0) {
                check.backgroundColor = UIColor.white
            } else {
                check.backgroundColor = UIColor.systemYellow
            }
            
        } else {
            performSegue(withIdentifier: "toScoreVC", sender: nil)
        }
        
    }
    
    
    // 前の単語をセットする処理
    func backWords() {
        if(0<wordsCount && wordsCount<=csvArray.count) {
            wordsCount -= 1
            slider.value = Float(wordsCount) // ボタンを押すたびにスライダーを左に移動
            wordsArray = csvArray[wordsCount].components(separatedBy: ",")
            wordNumberLabel.text = "\(wordsCount+1) / \(csvArray.count)"
            wordsView.setTitle(wordsArray[language], for: .normal)
        }
        
        if(checkbuttonColor[wordsCount]==0) {
            check.backgroundColor = UIColor.white
        } else {
            check.backgroundColor = UIColor.systemYellow
        }
    }
    
    
    // この画面が表示されるたびに実行される処理(画面が表示される直前)
    override func viewWillAppear(_ animated: Bool) {
        wordsCount = 0
        wordsArray = csvArray[wordsCount].components(separatedBy: ",")
        wordNumberLabel.text = "\(wordsCount+1) / \(csvArray.count)" // 単語番号の表示
        wordsView.setTitle(wordsArray[language], for: .normal) // 単語の表示
        slider.value = 0 // スライダーのつまみの位置を左端に移動
        
        if(checkbuttonColor[wordsCount]==0) {
            check.backgroundColor = UIColor.white
        } else {
            check.backgroundColor = UIColor.systemYellow
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
    

    // 「☆単語へ」のボタンを無効化するかどうか判定
    func buttonEnable() {
        var total = 0
        for i in 0..<csvArray.count {
            total += checkbuttonColor[i]
        }
        
        // totalの値が0なら「☆単語へ」のボタンを無効化,そうでないなら有効化
        if(total == 0) {
            moveCheckwords.isEnabled = false
        } else {
            moveCheckwords.isEnabled = true
        }
    }
    
    
    // 単語にマークをつける，☆ボタンの操作
    @IBAction func check(_ sender: UIButton) {
        if(checkbuttonColor[wordsCount] == 0) {
            sender.backgroundColor = UIColor.systemYellow
            checkbuttonColor[wordsCount] = 1
            buttonEnable()
        } else {
            sender.backgroundColor = UIColor.white
            checkbuttonColor[wordsCount] = 0
            buttonEnable()
        }
    }
    
    
    // 単語のマーク情報を別の画面に渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCheckWord" {
            let A = segue.destination as! CheckWordViewController
            A.whethermark = checkbuttonColor
            A.kind = kind
            A.material = material
        }
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
