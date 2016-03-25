////
////  BlueToothPrintVC.swift
////  LegalAffairsDepartment
////
////  Created by 柯锐 on 16/3/16.
////  Copyright © 2016年 WKZF. All rights reserved.
////
//
//import Foundation
//import UIKit
//import CoreBluetooth
//
//class BlueToothPrintVC :UIViewController ,UITableViewDelegate, UITableViewDataSource{
//    var tableView: UITableView!
//    var topConstraint: Constraint?
//    let topMarginValue:Int = 80
//    //添加属性
//    var manager: CBCentralManager!
//    var peripheral: CBPeripheral!
//    var writeCharacteristic: CBCharacteristic!
//    //保存收到的蓝牙设备
//    var deviceList:NSMutableArray = NSMutableArray()
//    var adHeaders:[String]?
//    // var allnames:Dictionary<Int, [String]>?
//    var timmer:NSTimer?
//    let titleWk = "悟空找房"
//    var qrCodeWk = ""
//    var houseNumber :String!
//    var ENTER = "\n"
//    var cbProperties = CBCharacteristicProperties.Write
//    var cbPermissions = CBAttributePermissions.Writeable
//    var footerView :UIView!
//    var businessId: String?
//    var printCount: Int = 0
//    var cityId :String?
//    var caseName: String?
//    var printToast: PrintToastUI!
//    var layout:UIView!
//    //当前屏幕对象
//    var screenObject=UIScreen.mainScreen().bounds;
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //1.创建一个中央对象
//        self.manager = CBCentralManager(delegate: self, queue: nil)
//        initview()
//    }
//    
//    func initview (){
//        
//        self.title = "选择连接设备"
//        houseNumber = "业务流水号:" + businessId!
//        qrCodeWk = businessId!
//        self.adHeaders = [
//            "现有设备",
//            "新增设备"
//        ]
//        
//        // 布局
//        layout = UIView()
//        self.view.addSubview(layout)
//        layout.snp_makeConstraints { (make) -> Void in
//            make.edges.equalTo(self.view)
//        }
//        
//        
//        
//    }
//    
//    //搜索设备
//    func  discoverDevice(){
//        manager!.scanForPeripheralsWithServices(nil , options: nil)
//    }
//    
//    
//    /**
//     我的资料表格初始化
//     */
//    func creatTable(){
//        let dataTableW:CGFloat=screenObject.width;
//        let dataTableH:CGFloat=screenObject.height;
//        let dataTableX:CGFloat=0;
//        let dataTableY:CGFloat=0;
//        tableView=UITableView(frame: CGRectMake(dataTableX, dataTableY, dataTableW, dataTableH-50),style:UITableViewStyle.Grouped);
//        tableView.delegate=self//实现代理
//        tableView.dataSource=self//实现数据源
//        //创建一个重用的单元格
//        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SwiftCell")
//        footerView = UIView()
//        
//        //确认打印
//        print("\(dataTableH)"+"------------------------------>")
//        let confirmButton: UIButton = UIButton(frame :CGRectMake(100,550, 200, 50))
//        confirmButton.setTitle("搜索更多设备", forState: UIControlState.Normal)
//        confirmButton.setTitleColor(UIColor.init(rgb:0x4081d6), forState: UIControlState.Normal)
//        confirmButton.layer.cornerRadius = 25
//        confirmButton.backgroundColor = UIColor.whiteColor()
//        confirmButton.layer.borderColor = UIColor.init(rgb:0x4081d6).CGColor
//        confirmButton.layer.borderWidth = 1
//        
//        let topImage  =  UIImageView(image: UIImage(named: "scan_blue_start"))
//        confirmButton.addSubview(topImage)
//        topImage.snp_makeConstraints { (make) -> Void in
//            make.centerY.equalTo(confirmButton)
//            make.left.equalTo(dataTableW/4-80)
//        }
//        
//        self.view.addSubview(confirmButton);
//        
//        // tableView.addSubview(confirmButton)
//        
//        // footerView.addSubview(confirmButton)
//        // searchLabel.
//        
//        self.tableView.tableFooterView = footerView
//        self.layout.addSubview(tableView);
//    }
//    
//    //内存警告
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning();
//        print("个人信息内存警告");
//    }
//    
//    
//    func alertDailogshow(){
//        //初始化提示框；
//        let alertcontroller : UIAlertController = UIAlertController(title: "连接成功确认打印吗", message:"", preferredStyle: UIAlertControllerStyle.Alert)
//        alertcontroller.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel)
//        {(UIAlertAction) -> Void in NSLog("")})
//        
//        alertcontroller.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default)
//        {(UIAlertAction) -> Void in self.printControl() })
//        self.presentViewController(alertcontroller, animated: true,completion: nil)
//    }
//    
//    func printControl(){
//        timmer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:#selector(BlueToothPrintVC.BTPrint), userInfo:nil, repeats:true)
////        printToast  = PrintToastUI.init( alertPlaceholder:"二维码打印中...")
////        printToast.show()
//        
//        
//    }
//    
//    
//    //数据处理
//    func BTPrint(){
//        if(printCount == 0){
//            printCount = 2
//            timmer?.invalidate()
//            printToast.close()
//            successPage()
//            
//            return
//        }
//        printCount -= 1
//        
//        let cfEnc = CFStringEncodings.GB_18030_2000
//        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
//        //
//        let temp: [CChar]  = [0x0a];   //换行
//        let center: [CChar]  = [0x1b, 0x61, 0x01];
//        let original2: [CChar]  = [0x1d, 0x21, 0x22];    //倍高倍宽2倍
//        let titleArraypt: [CChar] = titleWk.cStringUsingEncoding(enc)!   //标题
//        let zongzuobiao: [CChar]  = [0x1d, 0x24, 0x00, 0x01];
//        let  original4: [CChar]  = [0x1d, 0x21, 0x00];    //初始化
//        let SetQRcodeParameter: [CChar] = [0x1d, 0x6f, 0x00, 0x0d, 0x00, 0x02];   //第4个参数是设置二维码大小的
//        let  QRcodeZhiLingTou: [CChar] = [0x1d, 0x6b, 0x4b];
//        let qrcodeArray: [CChar] = qrCodeWk.cStringUsingEncoding(enc)!
//        let caseNameArray: [CChar] = caseName!.cStringUsingEncoding(enc)!
//        let houseNumberArray: [CChar] = houseNumber.cStringUsingEncoding(enc)!
//        let thridOnewArray : [CChar] = [0x31]
//        let thridTwowArray : [CChar] = [0x32]
//        let qrlentha = qrCodeWk.characters.count + 2
//        let length: [CChar] = [CChar(qrlentha)]
//        let twelve: [CChar] = [0x0c]
//        
//        
//        
//        let tempData: NSData = NSData(bytes: temp, length: temp.count)
//        let centerdata: NSData = NSData(bytes: center, length: center.count)
//        let original2data: NSData = NSData(bytes: original2, length: original2.count)
//        let titleArrayptdata: NSData = NSData(bytes: titleArraypt, length: titleArraypt.count)
//        let zongzuobiaodata: NSData = NSData(bytes: zongzuobiao, length: zongzuobiao.count)
//        let original4data: NSData = NSData(bytes: original4, length: original4.count)
//        // SetQRcodeParameter[3] = NumPrint!;
//        let SetQRcodeParameterData: NSData = NSData(bytes: SetQRcodeParameter, length: SetQRcodeParameter.count)
//        let QRcodeZhiLingTouData: NSData = NSData(bytes: QRcodeZhiLingTou, length: QRcodeZhiLingTou.count)
//        let qrcodeArraydata: NSData = NSData(bytes: qrcodeArray, length: qrcodeArray.count)
//        let caseNamedata: NSData = NSData(bytes: caseNameArray, length: caseNameArray.count)
//        let houseNumberdata: NSData = NSData(bytes: houseNumberArray, length: houseNumberArray.count)
//        let thridOnewArrayData: NSData = NSData(bytes: thridOnewArray, length: thridOnewArray.count)
//        let thridTwowArrayData: NSData = NSData(bytes: thridTwowArray, length: thridTwowArray.count)
//        let twelveData: NSData = NSData(bytes: twelve, length: twelve.count)
//        let lengthData: NSData = NSData(bytes: length, length: length.count)
//        
//        
//        // self.writeValue(tempData)
//        //  self.writeValue(tempData)
//        //self.writeValue(centerdata)
//        self.writeValue(original2data)
//        self.writeValue(tempData)
//        //self.writeValue(tempData)
//        self.writeValue(titleArrayptdata)
//        self.writeValue(tempData)
//        self.writeValue(tempData)
//        //
//        //        self.writeValue(tempData)
//        //        self.writeValue(tempData)
//        //        self.writeValue(tempData)
//        //        self.writeValue(tempData)
//        
//        self.writeValue(zongzuobiaodata)
//        self.writeValue(centerdata)
//        self.writeValue(original4data)
//        self.writeValue(SetQRcodeParameterData)
//        self.writeValue(QRcodeZhiLingTouData)
//        self.writeValue(lengthData)
//        self.writeValue(thridOnewArrayData)
//        self.writeValue(thridTwowArrayData)
//        self.writeValue(qrcodeArraydata)
//        self.writeValue(tempData)
//        self.writeValue(tempData)
//        self.writeValue(caseNamedata)
//        self.writeValue(tempData)
//        
//        self.writeValue(houseNumberdata)
//        self.writeValue( tempData)
//        self.writeValue(twelveData)
//        
//        
//    }
//    
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 2
//    }
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        var headers =  self.adHeaders!;
//        return headers[section];
//        
//    }
//    
//    //    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//    //        <#code#>
//    //    }
//    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        //        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
//        //        footerView.backgroundColor = UIColor.blackColor()
//        
//        return nil
//    }
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        
//        return self.deviceList.count
//        
//        
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let identifier="identtifier";
//        var cell=tableView.dequeueReusableCellWithIdentifier(identifier);
//        if(cell == nil){
//            cell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier);
//        }
//        
//        let device:CBPeripheral=self.deviceList.objectAtIndex(indexPath.row) as! CBPeripheral
//        //主标题
//        cell!.textLabel?.text = device.name
//        //副标题
//        cell!.detailTextLabel?.text = device.identifier.UUIDString
//        return cell!
//    }
//    
//    //通过选择来连接和断开外设
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if(self.deviceList.containsObject(self.deviceList.objectAtIndex(indexPath.row))){
//            
//            self.manager.connectPeripheral(self.deviceList.objectAtIndex(indexPath.row) as! CBPeripheral, options: nil)
//            // self.manager.cancelPeripheralConnection(self.deviceList.objectAtIndex(indexPath.row) as! CBPeripheral)
//            // self.deviceList.removeObject(self.deviceList.objectAtIndex(indexPath.row))
//            // print("蓝牙已断开！")
//        }else{
//            discoverDevice()
//            self.manager.connectPeripheral(self.deviceList.objectAtIndex(indexPath.row) as! CBPeripheral, options: nil)
//            //self.deviceList.addObject(self.deviceList.objectAtIndex(indexPath.row))
//            print("蓝牙已连接！ \(self.deviceList.count)")
//        }
//        
//    }
//    //失败页面
//    
//    func errorPage(){
//        let printerError :PrinterErrorVC = PrinterErrorVC()
//        printerError.reason = "连接失败"
//        self.presentViewController(printerError, animated: true, completion: nil)
//    }
//    //成功页面
//    func successPage(){
//        //socket.disconnect()
//        let printSucessVC :PrintSucessVC = PrintSucessVC()
//        printSucessVC.businessName = self.caseName
//        printSucessVC.businessId = self.businessId
//        printSucessVC.cityId = self.cityId
//        self.navigationController!.pushViewController(printSucessVC, animated: true)
//    }
//    
//}
////蓝牙Delegate
//extension BlueToothPrintVC :CBCentralManagerDelegate, CBPeripheralDelegate {
//    
//    
//    //2.检查运行这个App的设备是不是支持BLE。代理方法
//    func centralManagerDidUpdateState(central: CBCentralManager){
//        switch central.state {
//        case CBCentralManagerState.PoweredOn:
//            //扫描周边蓝牙外设.
//            //写nil表示扫描所有蓝牙外设，如果传上面的kServiceUUID,那么只能扫描出FFEO这个服务的外设。
//            //CBCentralManagerScanOptionAllowDuplicatesKey为true表示允许扫到重名，false表示不扫描重名的。
//            self.manager.scanForPeripheralsWithServices(nil, options:[CBCentralManagerScanOptionAllowDuplicatesKey: false])
//            print("蓝牙已打开,请扫描外设")
//            discoverDevice()
//            
//        case CBCentralManagerState.Unauthorized:
//            print("这个应用程序是无权使用蓝牙低功耗")
//        case CBCentralManagerState.PoweredOff:
//            print("蓝牙目前已关闭")
//        default:
//            print("中央管理器没有改变状态")
//        }
//    }
//    
//    
//    //3.查到外设
//    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
//        print("Discovered \(peripheral.name)")
//        print("CenCentalManagerDelegate didDiscoverPeripheral /n")
//        print("Rssi: \(RSSI)")
//        creatTable();
//        if(!self.deviceList.containsObject(peripheral)){
//            self.deviceList.addObject(peripheral)
//            self.tableView.reloadData()
//        }
//        
//        
//        print("peripheral.RSSI:  \(peripheral.identifier.UUIDString)")
//        // device.identifier.UUIDString
//        
//        self.peripheral = peripheral
//        
//        
//        //连接蓝牙
//        //  manager!.connectPeripheral(peripheral, options: nil)
//        
//    }
//    //4.连接外设成功，开始发现服务
//    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral){
//        print("连接外设成功")
//        
//        
//        //停止扫描外设
//        self.manager.stopScan()
//        self.peripheral = peripheral
//        self.peripheral.delegate = self
//        self.peripheral.discoverServices(nil)
//        
//        
//    }
//    
//    //连接外设失败
//    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?){
//        print("连接外设失败===\(error)")
//    }
//    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
//        print("断开连接")
//    }
//    
//    
//    //          //5.请求周边去寻找它的服务所列出的特征
//    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?){
//        if error != nil {
//            print("错误的服务特征:\(error!.localizedDescription)")
//            return
//        }
//        
//        for service in peripheral.services! {
//            print("服务的UUID:\(service.UUID)")
//            
//            peripheral.discoverCharacteristics(nil ,forService: service as CBService)
//            
//        }
//    }
//    
//    //6.已搜索到Characteristics
//    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?){
//        //print("发现特征的服务:\(service.UUID.data)   ==  服务UUID:\(service.UUID)")
//        if (error != nil){
//            print("发现错误的特征：\(error!.localizedDescription)")
//            return
//        }
//        
//        for  characteristic in service.characteristics!  {
//            // characteristic.UUID.description
//            //罗列出所有特性，看哪些是notify方式的，哪些是read方式的，哪些是可写入的。
//            print("CBCharacteristic:\(characteristic)()  服务UUID:\(service.UUID)   特征UUID:\(characteristic.UUID)  properties:\(characteristic.properties)   value:\(characteristic.value)  isNotifying:\(characteristic.isNotifying)")
//            if(characteristic.UUID==CBUUID(string:"BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F")){ //---...测过....>
//                
//                //self.peripheral.setNotifyValue(true, forCharacteristic: characteristic as CBCharacteristic)
//                self.writeCharacteristic = characteristic as CBCharacteristic
//                self.peripheral.readValueForCharacteristic(characteristic as CBCharacteristic)
//                
//            }
//            
//        }
//        
//    }
//    
//    
//    
//    //8.获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
//    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?){
//        if(error != nil){
//            print("发送数据错误的特性是：\(characteristic.UUID)     错误信息：\(error!.localizedDescription)       错误数据：\(characteristic.value)")
//            return
//        }
//        
//        switch characteristic.UUID.description {
//        case "FFE1":
//            print("=\(characteristic.UUID)特征发来的数据是:\(characteristic.value)=")
//            
//        case "2A37":
//            print("=\(characteristic.UUID.description):\(characteristic.value)=")
//            
//        case "2A38":
//            var dataValue: Int = 0
//            characteristic.value!.getBytes(&dataValue, range:NSRange(location: 0, length: 1))
//            print("2A38的值为:\(dataValue)")
//            
//        case "Battery Level":
//            // 如果发过来的是Byte值，在Objective-C中直接.getBytes就是Byte数组了，在swift目前就用这个方法处理吧！
//            var batteryLevel: Int = 0
//            characteristic.value!.getBytes(&batteryLevel, range:NSRange(location: 0, length: 1))
//            print("当前为你检测了\(batteryLevel)秒！")
//            
//        case "Manufacturer Name String":
//            // //如果发过来的是字符串，则用NSData和NSString转换函数
//            let manufacturerName: NSString = NSString(data: characteristic.value!, encoding: NSUTF8StringEncoding)!
//            print("制造商名称为:\(manufacturerName)")
//            
//        case "6E400003-B5A3-F393-E0A9-E50E24DCCA9E":
//            print("=\(characteristic.UUID)特征发来的数据是:\(characteristic.value)=")
//            
//        case "6E400002-B5A3-F393-E0A9-E50E24DCCA9E":
//            print("返回的数据是:\(characteristic.value)")
//            
//        default:
//            break
//        }
//        self.alertDailogshow()
//    }
//    
//    //7.这个是接收蓝牙通知，很少用。读取外设数据主要用上面那个方法didUpdateValueForCharacteristic。
//    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?){
//        if error != nil {
//            print("更改通知状态错误：\(error!.localizedDescription)")
//        }
//        
//        print("收到的特性数据：\(characteristic.value)")
//        //如果它不是传输特性,退出.
//        //        if characteristic.UUID.isEqual(kCharacteristicUUID) {
//        //            return
//        //        }
//        //开始通知
//        if characteristic.isNotifying {
//            print("开始的通知\(characteristic)")
//            peripheral.readValueForCharacteristic(characteristic)
//        }else{
//            //通知已停止
//            //所有外设断开
//            //            print("通知\(characteristic)已停止设备断开连接")
//            //            self.manager.cancelPeripheralConnection(self.peripheral)
//        }
//    }
//    //
//    //          //写入数据
//    func writeValue(data: NSData!){
//        
//        peripheral.writeValue(data, forCharacteristic: self.writeCharacteristic, type: CBCharacteristicWriteType.WithResponse)
//        //
//        print("手机向蓝牙发送的数据为:\(data)")
//    }
//    //          //用于检测中心向外设写数据是否成功
//    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
//        if(error != nil){
//            print("发送数据失败!error信息:\(error)")
//        }else{
//            print("发送数据成功\(characteristic)")
//        }
//    }
//    
//    
//}