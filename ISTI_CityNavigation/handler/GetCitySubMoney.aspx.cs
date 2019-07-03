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
    public partial class GetCitySubMoney : System.Web.UI.Page
    {
        CitySubMoney_DB csm_db = new CitySubMoney_DB();
        Common com = new Common();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 查詢補助經費縣市分析
            ///說    明:
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string xmlstr = string.Empty;

                DataTable dt = csm_db.getCitySubsidyAnalyze();
                string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
                if (com.VeriftyToken(token))
                {
                    xmlstr = DataTableToXml.ConvertDatatableToXML(dt, "dataList", "data_item");
                    xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + "</root>";
                    xDoc.LoadXml(xmlstr);
                }
                else
                {
                    xDoc = ExceptionUtil.GetTokenErrorMassageDocument();
                    Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
                    xDoc.Save(Response.Output);
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