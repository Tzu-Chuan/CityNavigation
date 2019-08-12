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
        ImportData_Log idl_db = new ImportData_Log();
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
                string orgVer = (string.IsNullOrEmpty(Request["orgVer"])) ? "" : Request["orgVer"].ToString().Trim();
                cst_db.ChangeIDB_Version(ver);

                /// Log
                idl_db._IDL_Type = "IDB";
                idl_db._IDL_IP = Common.GetIPv4Address();
                idl_db._IDL_Description = "切換版本：Ver. " + orgVer + " 切換至 Ver. " + ver;
                idl_db._IDL_ModId = LogInfo.mGuid;
                idl_db._IDL_ModName = LogInfo.name;
                idl_db.addLog();

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