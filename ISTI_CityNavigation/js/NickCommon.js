/*-------------------------------------
Title：Common
Author：Nick Lai
Create Date：2018/11/08
Modify Date：2018/11/08
Version：1.0
-------------------------------------*/

$.extend({
    getQueryString: function (str) {
        ///---------------------------------------------------------------------------
        /// 功    能: 抓取Get參數之變數值
        ///---------------------------------------------------------------------------
        parName = str.replace(/[\[]/, '\\\[').replace(/[\]]/, '\\\]');
        var pattern = '[\\?&]' + str + '=([^&#]*)';
        var regex = new RegExp(pattern);
        var matches = regex.exec(window.location.href);
        if (matches == null) return '';
        else return decodeURIComponent(matches[1].replace(/\+/g, ' '));
    }
});