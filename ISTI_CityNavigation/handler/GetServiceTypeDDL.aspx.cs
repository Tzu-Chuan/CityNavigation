using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml;

namespace ISTI_CityNavigation.handler
{
    public partial class GetServiceTypeDDL : System.Web.UI.Page
    {
        CitySummaryTable_DB cst_db = new CitySummaryTable_DB();
        Common com = new Common();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 查詢應用服務別(下拉選單列表)
            ///說    明:
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string xmlstr = string.Empty;
                string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
                if (Common.VeriftyToken(token))
                {
                    DataTable dt = cst_db.getPlanType_ddl();

                    xmlstr = DataTableToXml.ConvertDatatableToXML(dt, "dataList", "data_item");
                    xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + "</root>";
                    xDoc.LoadXml(xmlstr);
                }
                else
                {
                    xDoc = ExceptionUtil.GetErrorMassageDocument("TokenFail");
                }
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