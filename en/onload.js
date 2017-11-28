var LogGrid
var tabbar
var dhxWins,win,winframe
var opt_net,opt_config
function load_tabbar()
{
  tabbar = new dhtmlXTabBar("Layer_TabStrip","top");
  tabbar.setImagePath("../../../codebase/tabbar/imgs/");
  tabbar.setSkinColors("#97A0A5");
  tabbar.setSkin("silver");
  tabbar.addTab("main_tab1","Commands");
  tabbar.addTab("main_tab2","Axis Control");
  tabbar.addTab("main_tab3","IOs");
  tabbar.addTab("main_tab4","Endurance Test");
  tabbar.addTab("main_tab5","Debug");
  tabbar.setContent( "main_tab1", Frame_Commands);
  tabbar.setContent( "main_tab2", Frame_AxisControl);
  tabbar.setContent( "main_tab3", Frame_IOs);
  tabbar.setContent( "main_tab4", Frame_Endurance);
  tabbar.setContent( "main_tab5", Frame_Debug);
  
  tabbar.enableAutoReSize( true );
  //tabbar.enableScroll( true );
  //tabbar.enableForceHiding ( true );
  //tabbar.enableAutoSize ( true );
  //tabbar.setHrefMode ( iframes );
  
  
  for ( var i = 1; i <= tabbar.getNumberOfTabs(); i++ )
  {
    tabbar.setCustomStyle( 'main_tab' + i, 'gray', 'black', 'font-size:10pt;font-family:Arial;font-weight: bold;' );
  }

  tabbar.hideTab("main_tab5");
  tabbar.setTabActive("main_tab1");
  tabbar.forceLoad("main_tab1");
};

function load_messagebox()
{
  LogGrid = new dhtmlXGridObject('MessageLogObj');
  LogGrid.setHeader("Date,Time,Information");
  LogGrid.setImagePath("../../../codebase/grid/imgs/");
  LogGrid.setInitWidths( "100,100,*");
  LogGrid.setColAlign ("center,center,left");
  LogGrid.setColTypes ("ro,ro,ro");
  LogGrid.setColSorting ("na,na,na");
  LogGrid.setSkin ("red_gray");
  LogGrid.setStyle("color:black;font-weight:bold;","color:black;","","")
  LogGrid.enableTooltips ("true,true,true");
  LogGrid.enableResizing ("false,false,false");
  LogGrid.enableMultiselect(false);
  LogGrid.enableAutoWidth (true);
  LogGrid.init();
};

function load_CANsetup()
{
var dhxForm,formStructure
formStructure = [

    {type:"settings",position:"label-top"},
    {type: "fieldset",name:"cansetup", label: "Can Setup", list:[
      {type: "combo", label: "Net", name: "combonet", options:[
      {text: "1", value: "0",selected: true},
      {text: "2", value: "1" }
      ]},
      {type:"newcolumn"},
      {type: "combo", label: "Configuration", name: "comboconfig",  inputLeft:50,  options:[
      {text: "Upstream", value: "0", selected: true},
      {text: "DownStream", value: "1" }
      ]},
      {type:"button", name:"Connect",width:100,offsetTop:10,offsetLeft:100, value:"Connect"}
    ]}
];
dhxWins = new dhtmlXWindows();
win = dhxWins.createWindow("cansetup", 100, 100, 500 , 200);
win.setText("CAN Setup");
win.attachURL("CanSetup.html");
win.center();
win.button("close").hide();
//win.keepInViewport();
winframe = win.getFrame();
};


dhtmlxEvent(window,"load",function()
{
  load_messagebox();
  load_tabbar();
  load_CANsetup();
  Layer_TabStrip.style.display = "none";
  Layer_MessageLog.style.display = "none";
  //Frame_Commands.style.display = "none";
  //Frame_AxisControl.style.display = "none";
  //Frame_IOs.style.display = "none";
  //Frame_Endurance.style.display = "none";
  //Frame_Debug.style.display = "none";
});

function onclick_btncanconnect()
{
  opt_config = winframe.contentWindow.document.getElementById("opt_config").value;
  opt_net = winframe.contentWindow.document.getElementById("opt_cannet").value;
  win.close();
}