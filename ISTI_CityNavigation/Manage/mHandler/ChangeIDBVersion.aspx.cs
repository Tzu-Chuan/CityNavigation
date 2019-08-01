using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml;

namespace ISTI_CityNavigation.Manage.mHandler
{
    public partial class ChangeIDBVersion : System.Web.UI.Page
    {
        CitySummaryTable_DB cst_db = new CitySummaryTable_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 變更版次
            ///說明:
            ///* Request["ver"]: 欲切換的版本
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string ver = (string.IsNullOrEmpty(Request["ver"])) ? "" : Request["ver"].ToString().Trim();
                cst_db.ChangeIDB_Version(ver);

                string xmlstr = "<?xml version='1.0' encoding='utf-8'?><root><Response>版本已切換為 Ver. " + ver + "</Response></root>";
                xDoc.LoadXml(xmlstr);
            }
            catch (Exception ex)
            {
                xDoc = ExceptionUtil.GetExceptionDocument(ex);
            }
            Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
            xDoc.Save(Response.Output);
        }
    }
}