//
//  bleTEST.m
//  blebleble
//
//  Created by Rui Pereira on 3/19/13.
//
//

#include "ofxBLE.h"
#import "BLE.h"

// Objective C class implementations

@interface ofxBLEDelegate ()

@end

@implementation ofxBLEDelegate

@synthesize dataDelegate;
@synthesize ble;
@synthesize receivedDATA;
@synthesize lengthOfDATA;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    ble = [[BLE alloc] init];
    [ble controlSetup:1];
    ble.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// ----------- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#pragma mark - BLE delegate

- (void)bleDidDisconnect
{
    NSLog(@"->Disconnected");
    
}

// When RSSI is changed, this will be called
-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
    NSString *test = rssi.stringValue;
    //cout << [test cStringUsingEncoding:NSASCIIStringEncoding] <<endl;
}

// When disconnected, this will be called
-(void) bleDidConnect
{
    NSLog(@"->Connected");
    
}

// When data is comming, this will be called
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    
   // NSLog(@"------- bleDidReceiveData");
    self.dataDelegate->didRecieveData(data,length);
    
}

#pragma mark - Actions

// Connect button will call to this
- (void)btnScanForPeripherals
{
    if (ble.activePeripheral)
        if(ble.activePeripheral.isConnected)
        {
            [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
//            [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
            return;
        }
    
    if (ble.peripherals)
        ble.peripherals = nil;
    
//    [btnConnect setEnabled:false];
    [ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
//    [indConnecting startAnimating];
}

-(void) connectionTimer:(NSTimer *)timer
{
//    [btnConnect setEnabled:true];
//    [btnConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
    

    if (ble.peripherals.count > 0)
    {
        [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
    }
    else
    {
//        [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
//        [indConnecting stopAnimating];
    }
}

//[someObject sendDigitalOut:self andBool:YES];
//-(void)sendDigitalOut:(id)sender andBool:(BOOL)someBool

//-(void)sendDigitalOut:(id)sender
-(void)sendDigitalOut:(id)sender state:(BOOL)bStatus
{
    UInt8 buf[3] = {0x01, 0x00, 0x00};
    
    if (bStatus)
        buf[1] = 0x01;
    else
        buf[1] = 0x00;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [ble write:data];
}

/* Send command to Arduino to enable analog reading */
-(void)sendAnalogIn:(id)sender state:(BOOL)bStatus
{
    UInt8 buf[3] = {0xA0, 0x00, 0x00};
    
    //if (bStatus){
        buf[1] = 0x01;
        cout<< "setting analog input ON"<<endl;
//    } else {
//        buf[1] = 0x00;
//        cout<< "setting analog input OFF"<<endl;

    //}
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [ble write:data];
}

// PWM slide will call this to send its value to Arduino
-(IBAction)sendPWM:(id)sender
{
    UInt8 buf[3] = {0x02, 0x00, 0x00};
    
//    buf[1] = sldPWM.value;
//    buf[2] = (int)sldPWM.value >> 8;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [ble write:data];
}

// Servo slider will call this to send its value to Arduino
-(IBAction)sendServo:(id)sender
{
    UInt8 buf[3] = {0x03, 0x00, 0x00};
    
//    buf[1] = sldServo.value;
//    buf[2] = (int)sldServo.value >> 8;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [ble write:data];
}

@end



// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//                                          C++ class implementation

ofxBLE::ofxBLE(){
    
    dongle = [[ofxBLEDelegate alloc]init];
    [dongle viewDidLoad];
    receivedDATA = 0;
}

ofxBLE::~ofxBLE(){

}

void ofxBLE::update(){
    

}


void ofxBLE::scanPeripherals(){
    [dongle btnScanForPeripherals];

}

void ofxBLE::sendDigitalOut(bool bState){
    //[dongle sendDigitalOut:0];
    [dongle sendDigitalOut:0 state:bState];

//    UInt8 buf[3] = {0x01, 0x00, 0x00};
//    
//    if (bState) buf[1] = 0x01;
//    else        buf[1] = 0x00;
//    
//    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
//    [dongle.ble write:data];
    
}

void ofxBLE::sendServo(float _val){
    // Servo slider will call this to send its value to Arduino
        UInt8 buf[3] = {0x03, 0x00, 0x00};
        
        buf[1] = _val;
        buf[2] = (int)_val >> 8;
        
        NSData *data = [[NSData alloc] initWithBytes:buf length:3];
        [dongle.ble write:data];

}



void ofxBLE::setAnalogInput(bool bState){
    /* Send command to Arduino to enable analog reading */

    [dongle sendAnalogIn:0];

}


void ofxBLE::setDataDelegate(testApp* delegate)
{
    if(delegate && this->dongle)
    {
        [dongle setDataDelegate:delegate];
    }
        
}


bool ofxBLE::isConnected(){
    
    return [dongle.ble isConnected];
}


