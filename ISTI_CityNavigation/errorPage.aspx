<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="errorPage.aspx.cs" Inherits="ISTI_CityNavigation.errorPage" %>

<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form runat="server">
     <div>
     <fieldset>
            <legend class="font_black font_size15">錯誤訊息</legend>
            <table>
                <tr>
                    <td class="font_black font_size15">
                        <br />
                        <asp:Label ID="Label1" runat="server"></asp:Label>                   
                    </td>
                </tr>
                <tr>
                    <td class="font_size13">
                        <asp:LinkButton id="lbtn_index" runat="server" OnClick="lbtn_index_Click">返回首頁</asp:LinkButton>
                        <asp:HiddenField ID="hid_token" runat="server" />
                    </td>
                </tr>
             </table>
        </fieldset>
    </div>
    </form>
</body>
</html>
