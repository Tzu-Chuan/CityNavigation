// JavaScript Document
$(document).ready(MainFunction);//主程式:所有JS程式放在此
$(window).resize(breakpointhandle);
//主程式內容
	function MainFunction(){
    mmenuFun();//選單程式
    RWDsetting();//RWD佈局操作

	$('.itemhint').powerTip({placement:'e',smartPlacement:true,});//powertip:tooltip
    $('.itemhintfollow').powerTip({placement:'e',smartPlacement:true,followMouse:true});//powertip:tooltip
	$('.itemhinthold').powerTip({placement:'e',smartPlacement:true,mouseOnToPopup:'true'});//tooltip可點選
	
	//datepicker
	$(".Jdatepicker").datetimepicker({
		format:'Y/m/d',
		timepicker:false,
		withoutBottomPanel: true,
		scrollInput:false,//取消input滾動調整日期功能
		//yearEnd:2022,//下拉選單最末年份
		});
	
	//Magnific Popup
	$('.open-popup-link').magnificPopup({
  		type:'inline',
  		midClick: false, // 是否使用滑鼠中鍵
  		closeOnBgClick:true,//點擊背景關閉視窗
  		showCloseBtn:true,//隱藏關閉按鈕
  		fixedContentPos:true,//彈出視窗是否固定在畫面上
  		mainClass: 'mfp-fade',//加入CSS淡入淡出效果
  		tClose: '關閉',//翻譯字串
	});

	/*  Magnific Popup自動播放 
	$.magnificPopup.open({
    	items: {
        	src: '#test-popup'//要自動播放的ID 
    	},
    	type: 'inline'
     });
	*/
	//Magnific Popup關閉動作
	$(".closemagnificPopup").click(function(){
		$.magnificPopup.close();
	});

    //scrollbar美化
    $('.scrollbar-macosx').scrollbar();//滑鼠移上後再顯示
    $('.scrollbar-outer').scrollbar();//純美化

        var controller = new ScrollMagic();
        var sceneheaderPin = new ScrollScene({triggerElement: ".WrapperHeader"})
            .setPin(".WrapperHeader").triggerHook(0)
            .addTo(controller);
        var scenetitlePin = new ScrollScene({triggerElement: ".WrapperHeader"})
            .setPin(".MainMenu").triggerHook(0)
            .addTo(controller);

        //scenemenuPin.addIndicators({zindex:100});

	}//MainFunction

function RWDsetting(){
    //設定桌機版選單寬度，當行動版時，以0來隱藏。
    var DeskMenu = $("#DeskSidebarMmenu");
    var DeskMenuWidth = "250px";
    var MobMenuWidth = 0;
    DeskMenu.css("width",DeskMenuWidth);
    //內容容器，桌機時要右縮。內容共兩種尺寸
    var WrapperContent = $(".WrapperContent");
    var containerL = $(".WrapperContent .containerL");
    var containerS = $(".WrapperContent .containerS");
    var containerLWidth = "1420px";
    var containerSWidth = "960px";
    containerL.css("max-width",containerLWidth);
    containerS.css("max-width",containerSWidth);
    //固定選單處理
    var WrapperHeader = $(".WrapperHeader");
    var MainMenu = $(".MainMenu");
    var HeaderHeight = $(".WrapperHeader").height();
    WrapperHeader.css({"z-index":"97"});
    MainMenu.css({"z-index":"98"});
    DeskMenu.css({"position":"fixed","top":HeaderHeight + "px","z-index":"99"});
    //選單切換按鈕
    var mmenuMobswitch = $("#mmenuMobswitch");


    //選單開關
    $("#mmenuMobswitch").click(function(){
        if(DeskMenu.css('display') == 'none'){
            DeskMenu.show()
            WrapperContent.css("padding-left",DeskMenuWidth);
            mmenuMobswitch.attr({"class":"fa fa-chevron-left itemhint"});
        } else {
            DeskMenu.hide();
            WrapperContent.css("padding-left",MobMenuWidth);
            mmenuMobswitch.attr({"class":"fa fa-chevron-right itemhint"});
        }
    });


}



//處理尺寸斷點
	function breakpointhandle(){


        //設定斷點:判斷螢幕尺寸決定內容
        //桌機狀態:瀏覽器大於 960
        $.breakpoint({
            condition: function () {
                return window.matchMedia('all and (min-width:961px)').matches;
            },
            enter: function () {

            },
        });

        //平板手機狀態:瀏覽器介於 960~480
        $.breakpoint({
            condition: function () {
                return window.matchMedia('all and (max-width:960px) and (min-width:480px)').matches;
            },
            enter: function () {

            },

        });

        //手機狀態:瀏覽器小於 480 且為橫式
        $.breakpoint({
            condition: function () {
                return window.matchMedia('all and (max-width:479px) and (orientation:landscape)').matches;
            },
            enter: function () {

            },
        });

        //手機狀態:尺寸小於 480 且為直立 orientation:portrait
        $.breakpoint({
            condition: function () {
                return window.matchMedia('all and (max-width:479px) and (orientation:portrait)').matches;
            },
            enter: function () {

            },

        });
	}


//選單處理mmenu
	function mmenuFun(){

	//啟動mmenu for 桌機
	$("#DeskSidebarMmenu").mmenu({
        //extensions: ["position-right"],//選單方向
		slidingSubmenus:false,//設定下拉選單為直接向下展開,而非滑動
        offCanvas: false,//讓選單崁入頁面區塊
        navbar: {
            title: ""//空值移除narbar上的title
        },

    });

    }//mmenuFun




//外部連結處理
var clonetopmenu = $("#HeaderOtherLink").clone(false);
clonetopmenu.remove("#HeaderOtherLink").appendTo($("#HeaderOtherLinkCopy"));



