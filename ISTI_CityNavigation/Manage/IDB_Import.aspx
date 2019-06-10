<%@ Page Title="" Language="C#" MasterPageFile="~/Manage/BackEnd.Master" AutoEventWireup="true" CodeBehind="IDB_Import.aspx.cs" Inherits="ISTI_CityNavigation.Manage.IDB_Import" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        //上傳按鈕
        $(document).ready(function () {
            $("#upbtn").click(function () {
                try {
                    if ($("#file0").val() == "") {
                        alert("請選擇要匯入的檔案");
                        return;
                    }
                    var exten = $("#file0").val().replace(/^.*\./, '');
                    var PassExten = ["xls", "xlsx"];
                    if ($.inArray(exten, PassExten) == -1) {
                        alert("請上傳Excel檔");
                        return;
                    }
                    var iframe = $('<iframe name="postiframe" id="postiframe" style="display: none" />');
                    //var year = $('<input type="hidden" name="year" id="year" value="' + $.getParamValue('year') + '" />');
                    var form = $("form")[0];

                    //如果沒有重新導頁需要刪除上次資訊
                    $("#postiframe").remove();
                    //$("input[name='year']").remove();

                    form.appendChild(iframe[0]);
                    //form.appendChild(year[0]);

                    form.setAttribute("action", "mHandler/ImportIDBFile.aspx");
                    form.setAttribute("method", "post");
                    form.setAttribute("enctype", "multipart/form-data");
                    form.setAttribute("encoding", "multipart/form-data");
                    form.setAttribute("target", "postiframe");
                    form.submit();
                }
                catch (ex) {
                    alert(ex.message);
                }
            });
        });

        function feedbackFun(msg) {
            alert(msg);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="margin-top:10px;">
        <input id="file0" name="file0" type="file" class="inputex" />
        <input id="upbtn" type="button" class="genbtn" value="上傳" />
    </div>
</asp:Content>
