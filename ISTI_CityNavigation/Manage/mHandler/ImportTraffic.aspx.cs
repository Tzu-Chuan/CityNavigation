using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NPOI.SS.UserModel;//-- v.1.2.4起 新增的。
using NPOI.XSSF.UserModel;//-- XSSF 用來產生Excel 2007檔案（.xlsx）
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace ISTI_CityNavigation.Manage.mHandler
{
    public partial class ImportTraffic : System.Web.UI.Page
    {
        Traffic_DB TC_DB = new Traffic_DB();
        ImportData_Log idl_db = new ImportData_Log();
        //建立共用參數
        string strErrorMsg = "";
        int strMaxVersion = 0;
        string chkYear = "";
        DateTime dtNow = DateTime.Now;
        protected void Page_Load(object sender, EventArgs e)
        {
            //讀取Token值
            string token = (string.IsNullOrEmpty(Request["InfoToken"])) ? "" : Request["InfoToken"].ToString().Trim();
            if (VeriftyToken(token))
            {
                //建立共用connection & transaction
                SqlConnection oConn = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"].ToString());
                oConn.Open();
                SqlCommand oCmd = new SqlCommand();
                oCmd.Connection = oConn;
                SqlTransaction myTrans = oConn.BeginTransaction();
                oCmd.Transaction = myTrans;

                //建立DataTable Bulk Copy用
                DataTable dt = new DataTable();
                dt.Columns.Add("Tra_CityNo", typeof(string)).MaxLength = 2;
                dt.Columns.Add("Tra_CityName", typeof(string)).MaxLength = 10;
                dt.Columns.Add("Tra_PublicTransportRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Tra_PublicTransportRate", typeof(string)).MaxLength = 7;
                dt.Columns.Add("Tra_CarParkTimeYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Tra_CarParkTime", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Tra_CarParkSpaceYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Tra_CarParkSpace", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Tra_10KHaveCarParkYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Tra_10KHaveCarPark", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Tra_CarCountYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Tra_CarCount", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Tra_100HaveCarYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Tra_100HaveCar", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Tra_100HaveCarRateYearDec", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Tra_100HaveCarRate", typeof(string)).MaxLength = 7;
                dt.Columns.Add("Tra_10KMotoIncidentsNumYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Tra_10KMotoIncidentsNum", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Tra_100KNumberOfCasualtiesYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Tra_100KNumberOfCasualties", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Tra_CreateDate", typeof(DateTime));
                dt.Columns.Add("Tra_CreateID", typeof(string));
                dt.Columns.Add("Tra_CreateName", typeof(string));
                dt.Columns.Add("Tra_Status", typeof(string));
                dt.Columns.Add("Tra_Version", typeof(int));

                try
                {
                    HttpFileCollection uploadFiles = Request.Files;//檔案集合
                    HttpPostedFile aFile = uploadFiles[0];
                    //判斷有沒有檔案
                    if (uploadFiles.Count < 1 || aFile.FileName == "")
                    {
                        throw new Exception("請選擇檔案");
                    }

                    //有檔案繼續往下做
                    if (uploadFiles.Count > 0)
                    {
                        string extension = (System.IO.Path.GetExtension(aFile.FileName) == "") ? "" : System.IO.Path.GetExtension(aFile.FileName);
                        if (extension != ".xls" && extension != ".xlsx")
                        {
                            throw new Exception("請選擇xls或xlsx檔案上傳");
                        }

                        IWorkbook workbook;// = new HSSFWorkbook();//创建Workbook对象
                        workbook = new XSSFWorkbook(aFile.InputStream);

                        ISheet sheet = workbook.GetSheetAt(0);//當前sheet

                        //簡易判斷這份Excel是不是交通的Excel
                        int cellsCount = sheet.GetRow(0).Cells.Count;
                        //1.判斷表頭欄位數
                        if (cellsCount != 10)
                        {
                            throw new Exception("請檢查是否為交通的匯入檔案");
                        }
                        //2.檢查欄位名稱
                        if (sheet.GetRow(0).GetCell(1).ToString().Trim() != "通勤學民眾運具次數之公共運具市佔率" || sheet.GetRow(0).GetCell(2).ToString().Trim() != "自小客車在居家附近每次尋找停車位時間")
                        {
                            throw new Exception("請檢查是否為交通的匯入檔案");
                        }

                        //取得當前最大版次 (+1變成現在版次)
                        strMaxVersion = TC_DB.getMaxVersin() + 1;

                        //取得代碼檔
                        CodeTable_DB code_db = new CodeTable_DB();
                        DataTable dtCode = code_db.getCommonCode("02");

                        string cityNo = string.Empty;

                        //資料從第四筆開始 最後一筆是合計不進資料庫
                        for (int j = 3; j < sheet.PhysicalNumberOfRows - 1; j++)
                        {
                            if (sheet.GetRow(j).GetCell(0).ToString().Trim() != "" && sheet.GetRow(j).GetCell(0).ToString().Trim() != "全台平均")
                            {
                                DataRow row = dt.NewRow();
                                cityNo = Common.GetCityCodeItem(dtCode, sheet.GetRow(j).GetCell(0).ToString().Trim());//縣市代碼
                                if (cityNo == "")
                                {
                                    throw new Exception("第" + (j + 1) + "筆資料：" + sheet.GetRow(j).GetCell(0).ToString().Trim() + "不是一個正確的縣市名稱");
                                }

                                strErrorMsg = "行數:第" + (j + 1).ToString() + " 筆<br>";
                                row["Tra_CityNo"] = cityNo;//縣市代碼
                                row["Tra_CityName"] = sheet.GetRow(j).GetCell(0).ToString().Trim();//縣市名稱
                                row["Tra_PublicTransportRateYear"] = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");//通勤學民眾運具次數之公共運具市佔率-資料年度(民國年)
                                row["Tra_PublicTransportRate"] = sheet.GetRow(j).GetCell(1).ToString().Trim();//通勤學民眾運具次數之公共運具市佔率-%
                                row["Tra_CarParkTimeYear"] = sheet.GetRow(1).GetCell(2).ToString().Trim().Replace("年", "");//自小客車在居家附近每次尋找停車位時間-資料年度(民國年)
                                row["Tra_CarParkTime"] = sheet.GetRow(j).GetCell(2).ToString().Trim();//自小客車在居家附近每次尋找停車位時間-分鐘
                                row["Tra_CarParkSpaceYear"] = sheet.GetRow(1).GetCell(3).ToString().Trim().Replace("年", "");//小汽車路邊及路外停車位-資料年度(民國年)
                                row["Tra_CarParkSpace"] = sheet.GetRow(j).GetCell(3).ToString().Trim();//小汽車路邊及路外停車位-個
                                row["Tra_10KHaveCarParkYear"] = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");//每萬輛小型車擁有路外及路邊停車位數-資料年度(民國年)
                                row["Tra_10KHaveCarPark"] = sheet.GetRow(j).GetCell(4).ToString().Trim();//每萬輛小型車擁有路外及路邊停車位數-位／萬輛
                                row["Tra_CarCountYear"] = sheet.GetRow(1).GetCell(5).ToString().Trim().Replace("年", "");//汽車登記數-資料年度(民國年)
                                row["Tra_CarCount"] = sheet.GetRow(j).GetCell(5).ToString().Trim();//汽車登記數-輛
                                row["Tra_100HaveCarYear"] = sheet.GetRow(1).GetCell(6).ToString().Trim().Replace("年", "");//每百人擁有汽車數-資料年度(民國年)
                                row["Tra_100HaveCar"] = sheet.GetRow(j).GetCell(6).ToString().Trim();//每百人擁有汽車數-輛
                                row["Tra_100HaveCarRateYearDec"] = sheet.GetRow(1).GetCell(7).ToString().Trim();//每百人擁有汽車數成長率- ex:105-106年成長率
                                row["Tra_100HaveCarRate"] = sheet.GetRow(j).GetCell(7).ToString().Trim();//每百人擁有汽車數成長率-%
                                row["Tra_10KMotoIncidentsNumYear"] = sheet.GetRow(1).GetCell(8).ToString().Trim().Replace("年", "");//每萬輛機動車肇事數-資料年度(民國年)
                                row["Tra_10KMotoIncidentsNum"] = sheet.GetRow(j).GetCell(8).ToString().Trim();//每萬輛機動車肇事數-次
                                row["Tra_100KNumberOfCasualtiesYear"] = sheet.GetRow(1).GetCell(9).ToString().Trim().Replace("年", ""); ;//每十萬人道路交通事故死傷人數-資料年度(民國年)
                                row["Tra_100KNumberOfCasualties"] = sheet.GetRow(j).GetCell(9).ToString().Trim();//每十萬人道路交通事故死傷人數-人
                                row["Tra_CreateDate"] = dtNow;//建立時間
                                row["Tra_CreateID"] = LogInfo.mGuid;//上傳者GUID
                                row["Tra_CreateName"] = LogInfo.name;//上傳者姓名
                                row["Tra_Status"] = "A";//資料狀態
                                row["Tra_Version"] = strMaxVersion;//版次

                                if (chkYear == "")
                                    chkYear = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");

                                dt.Rows.Add(row);
                            }

                        }

                        if (dt.Rows.Count > 0)
                        {
                            strErrorMsg = "";
                            BeforeBulkCopy(oConn, myTrans, chkYear);//檢查資料表裡面是不是有該年的資料
                            DoBulkCopy(myTrans, dt);//匯入
                                                                 //最後再commit
                            myTrans.Commit();
                        }
                    }

                }
                catch (Exception ex)
                {
                    strErrorMsg += "錯誤訊息:" + ex.Message + "<br>";
                    strErrorMsg += "(欄位名稱請參考上傳範例檔)";
                    myTrans.Rollback();
                }
                finally
                {
                    oCmd.Connection.Close();
                    oConn.Close();

                    if (strErrorMsg == "")
                    {
                        /// Log
                        idl_db._IDL_Type = "ISTI";
                        idl_db._IDL_IP = Common.GetIPv4Address();
                        idl_db._IDL_Description = "檔案類別:交通 , 狀態：上傳成功";
                        idl_db._IDL_ModId = LogInfo.mGuid;
                        idl_db._IDL_ModName = LogInfo.name;
                        idl_db.addLog();
                        Response.Write("<script type='text/JavaScript'>parent.feedbackFun('交通匯入成功');</script>");
                    }
                    else
                    {
                        /// Log
                        idl_db._IDL_Type = "ISTI";
                        idl_db._IDL_IP = Common.GetIPv4Address();
                        idl_db._IDL_Description = "檔案類別:交通 , 狀態：上傳失敗";
                        idl_db._IDL_ModId = LogInfo.mGuid;
                        idl_db._IDL_ModName = LogInfo.name;
                        idl_db.addLog();
                        Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg.Replace("'", "") + "');</script>");
                    }
                }
            }
            else
            {
                strErrorMsg = "連線失敗請重新登入";
                Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg.Replace("'", "") + "');</script>");
            }
                
        }

        //insert 前判斷是不是同年份有資料了
        private void BeforeBulkCopy(SqlConnection oConn, SqlTransaction oTran, string chkYear)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@"
                declare @chkRowCount int = 0;
                select @chkRowCount = count(*) from Traffic where Tra_CarParkSpaceYear=@chkYear and Tra_Status='A'

                if @chkRowCount>0
                    begin
                        update Traffic set Tra_Status='D' where Tra_CarParkSpaceYear=@chkYear and Tra_Status='A'
                    end
            ");
            SqlCommand oCmd = oConn.CreateCommand();
            oCmd.CommandText = sb.ToString();

            oCmd.Parameters.AddWithValue("@chkYear", chkYear);

            oCmd.Transaction = oTran;
            oCmd.ExecuteNonQuery();
        }

        //交通 BulkCopy
        private void DoBulkCopy(SqlTransaction oTran, DataTable srcData)
        {
            SqlBulkCopyOptions setting = SqlBulkCopyOptions.CheckConstraints | SqlBulkCopyOptions.TableLock;
            using (SqlBulkCopy sqlBC = new SqlBulkCopy(oTran.Connection, setting, oTran))
            {
                sqlBC.BulkCopyTimeout = 600; ///設定逾時的秒數
                //sqlBC.BatchSize = 1000; ///設定一個批次量寫入多少筆資料, 設定值太小會影響效能 
                ////設定 NotifyAfter 屬性，以便在每複製 10000 個資料列至資料表後，呼叫事件處理常式。
                //sqlBC.NotifyAfter = 10000;
                ///設定要寫入的資料庫
                sqlBC.DestinationTableName = "Traffic";

                /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
                sqlBC.ColumnMappings.Add("Tra_CityNo", "Tra_CityNo");
                sqlBC.ColumnMappings.Add("Tra_CityName", "Tra_CityName");
                sqlBC.ColumnMappings.Add("Tra_PublicTransportRateYear", "Tra_PublicTransportRateYear");
                sqlBC.ColumnMappings.Add("Tra_PublicTransportRate", "Tra_PublicTransportRate");
                sqlBC.ColumnMappings.Add("Tra_CarParkTimeYear", "Tra_CarParkTimeYear");
                sqlBC.ColumnMappings.Add("Tra_CarParkTime", "Tra_CarParkTime");
                sqlBC.ColumnMappings.Add("Tra_CarParkSpaceYear", "Tra_CarParkSpaceYear");
                sqlBC.ColumnMappings.Add("Tra_CarParkSpace", "Tra_CarParkSpace");
                sqlBC.ColumnMappings.Add("Tra_10KHaveCarParkYear", "Tra_10KHaveCarParkYear");
                sqlBC.ColumnMappings.Add("Tra_10KHaveCarPark", "Tra_10KHaveCarPark");
                sqlBC.ColumnMappings.Add("Tra_CarCountYear", "Tra_CarCountYear");
                sqlBC.ColumnMappings.Add("Tra_CarCount", "Tra_CarCount");
                sqlBC.ColumnMappings.Add("Tra_100HaveCarYear", "Tra_100HaveCarYear");
                sqlBC.ColumnMappings.Add("Tra_100HaveCar", "Tra_100HaveCar");
                sqlBC.ColumnMappings.Add("Tra_100HaveCarRateYearDec", "Tra_100HaveCarRateYearDec");
                sqlBC.ColumnMappings.Add("Tra_100HaveCarRate", "Tra_100HaveCarRate");
                sqlBC.ColumnMappings.Add("Tra_10KMotoIncidentsNumYear", "Tra_10KMotoIncidentsNumYear");
                sqlBC.ColumnMappings.Add("Tra_10KMotoIncidentsNum", "Tra_10KMotoIncidentsNum");
                sqlBC.ColumnMappings.Add("Tra_100KNumberOfCasualtiesYear", "Tra_100KNumberOfCasualtiesYear");
                sqlBC.ColumnMappings.Add("Tra_100KNumberOfCasualties", "Tra_100KNumberOfCasualties");
                sqlBC.ColumnMappings.Add("Tra_CreateDate", "Tra_CreateDate");
                sqlBC.ColumnMappings.Add("Tra_CreateID", "Tra_CreateID");
                sqlBC.ColumnMappings.Add("Tra_CreateName", "Tra_CreateName");
                sqlBC.ColumnMappings.Add("Tra_Status", "Tra_Status");
                sqlBC.ColumnMappings.Add("Tra_Version", "Tra_Version");

                /// 開始寫入資料
                sqlBC.WriteToServer(srcData);
            }
        }

        //判斷Token是否正確
        private bool VeriftyToken(string clientToken)
        {
            if (string.IsNullOrEmpty(clientToken)) return false;

            string serverToken = HttpContext.Current.Session["Token"].ToString();
            if (clientToken.Equals(serverToken))
                return true;
            else
                return false;
        }
    }
}