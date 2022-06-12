//
//  SettingViewController.swift
//  Flashcard
//
//  Created by 原直輝 on 2021/12/21.
//

import UIKit

class SettingViewController: UIViewController {
    // 実験種類を選択するセグメントコントロール
    @IBOutlet weak var KindsegmentedControl: UISegmentedControl!
    // 学習素材を選択するセグメントコントロール
    @IBOutlet weak var MaterialsegmentedControl: UISegmentedControl!
    // 現在選択中の実験種類と学習素材の表示ラベル
    @IBOutlet weak var PresentLabel: UILabel!
    
    
    // 実験種類の選択用の変数
    var Kind:String = ""
    var KindNum:Int = 0 // 0ならKindをAに，1ならKindをBに
    // 学習回数の選択用の変数
    var Material:Int = 0
    
    // 画面が呼び出された際に行われる処理
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 実験種類の選択(A or B)
        KindNum = KindsegmentedControl.selectedSegmentIndex
        if(KindNum==0){
            Kind = "A"
        }else if(KindNum==1){
            Kind = "B"
        }
        
        // 学習回数の選択(1~4回目のいずれか)
        Material = MaterialsegmentedControl.selectedSegmentIndex + 1
        
        PresentLabel.text = "実験\(Kind)，\(Material)回目の学習"
    }
    

    // 実験種類を選択するセグメントコントロールの動作処理
    @IBAction func KindsegmentedControl(_ sender: UISegmentedControl) {
        KindNum = KindsegmentedControl.selectedSegmentIndex
        if(KindNum==0){
            Kind = "A"
        }else if(KindNum==1){
            Kind = "B"
        }
        PresentLabel.text = "実験\(Kind)，\(Material)回目の学習"
    }
    
    // 学習素材を選択するセグメントコントロールの動作処理
    @IBAction func MaterialsegmentedControl(_ sender: UISegmentedControl) {
        Material = sender.selectedSegmentIndex + 1
        PresentLabel.text = "実験\(Kind)，\(Material)回目の学習"
    }
    
    
    // 次画面に値を渡す処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let senni = segue.destination as! WordViewController
        senni.kind = Kind
        senni.material = Material
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
