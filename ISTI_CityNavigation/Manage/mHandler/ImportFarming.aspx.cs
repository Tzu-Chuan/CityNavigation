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
    public partial class ImportFarming : System.Web.UI.Page
    {
        Farming_DB FA_DB = new Farming_DB();
        ImportData_Log idl_db = new ImportData_Log();
        //建立共用參數
        string strErrorMsg = "";
        int strMaxVersion = 0;
        string chkYear = "";
        DateTime dtNow = DateTime.Now;
        protected void Page_Load(object sender, EventArgs e)
        {
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
                dt.Columns.Add("Fa_CityNo", typeof(string)).MaxLength = 2;
                dt.Columns.Add("Fa_CityName", typeof(string)).MaxLength = 10;
                dt.Columns.Add("Fa_FarmingLossYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Fa_FarmingLoss", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Fa_AnimalLossYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Fa_AnimalLoss", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Fa_FishLossYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Fa_FishLoss", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Fa_ForestLossYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Fa_ForestLoss", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Fa_AllLossYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Fa_AllLoss", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Fa_FacilityLossYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Fa_FacilityLoss", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Fa_FarmingOutputValueYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Fa_FarmingOutputValue", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Fa_FarmingOutputRateYearDesc", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Fa_FarmingOutputRate", typeof(string)).MaxLength = 7;
                dt.Columns.Add("Fa_FarmerYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Fa_Farmer", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Fa_FarmEmploymentOutputValueYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Fa_FarmEmploymentOutputValue", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Fa_CreateDate", typeof(DateTime));
                dt.Columns.Add("Fa_CreateID", typeof(string));
                dt.Columns.Add("Fa_CreateName", typeof(string));
                dt.Columns.Add("Fa_Status", typeof(string));
                dt.Columns.Add("Fa_Version", typeof(int));

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

                        //簡易判斷這份Excel是不是農業的Excel
                        int cellsCount = sheet.GetRow(0).Cells.Count;
                        //1.判斷表頭欄位數
                        if (cellsCount != 11)
                        {
                            throw new Exception("請檢查是否為農業的匯入檔案");
                        }
                        //2.檢查欄位名稱
                        if (sheet.GetRow(0).GetCell(1).ToString().Trim() != "臺閩地區農業天然災害產物損失" || sheet.GetRow(0).GetCell(2).ToString().Trim() != "天然災害畜牧業產物損失")
                        {
                            throw new Exception("請檢查是否為農業的匯入檔案");
                        }

                        //取得當前最大版次 (+1變成現在版次)
                        strMaxVersion = FA_DB.getMaxVersin() + 1;

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

                                strErrorMsg = "縣市名稱:" + sheet.GetRow(j).GetCell(0).ToString().Trim() + "<br>";
                                row["Fa_CityNo"] = cityNo;//縣市代碼
                                row["Fa_CityName"] = sheet.GetRow(j).GetCell(0).ToString().Trim();//縣市名稱
                                row["Fa_FarmingLossYear"] = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");//臺閩地區農業天然災害產物損失-資料年度(民國年)
                                row["Fa_FarmingLoss"] = sheet.GetRow(j).GetCell(1).ToString().Trim();//臺閩地區農業天然災害產物損失-千元
                                row["Fa_AnimalLossYear"] = sheet.GetRow(1).GetCell(2).ToString().Trim().Replace("年", "");//天然災害畜牧業產物損失-資料年度(民國年)
                                row["Fa_AnimalLoss"] = sheet.GetRow(j).GetCell(2).ToString().Trim();//天然災害畜牧業產物損失-千元
                                row["Fa_FishLossYear"] = sheet.GetRow(1).GetCell(3).ToString().Trim().Replace("年", "");//天然災害漁業產物損失-資料年度(民國年)
                                row["Fa_FishLoss"] = sheet.GetRow(j).GetCell(3).ToString().Trim();//天然災害漁業產物損失-千元
                                row["Fa_ForestLossYear"] = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");//臺閩地區林業天然災害產物損失-資料年度(民國年)
                                row["Fa_ForestLoss"] = sheet.GetRow(j).GetCell(4).ToString().Trim();//臺閩地區林業天然災害產物損失-千元
                                row["Fa_AllLossYear"] = sheet.GetRow(1).GetCell(5).ToString().Trim().Replace("年", "");//農林漁牧天然災害產物損失-資料年度(民國年)
                                row["Fa_AllLoss"] = sheet.GetRow(j).GetCell(5).ToString().Trim();//農林漁牧天然災害產物損失-千元
                                row["Fa_FacilityLossYear"] = sheet.GetRow(1).GetCell(6).ToString().Trim().Replace("年", "");//農林漁牧天然災害設施(備)損失-資料年度(民國年)
                                row["Fa_FacilityLoss"] = sheet.GetRow(j).GetCell(6).ToString().Trim();//農林漁牧天然災害設施(備)損失-千元
                                row["Fa_FarmingOutputValueYear"] = sheet.GetRow(1).GetCell(7).ToString().Trim().Replace("年", "");//農業產值-資料年度(民國年)
                                row["Fa_FarmingOutputValue"] = sheet.GetRow(j).GetCell(7).ToString().Trim();//農業產值-千元
                                row["Fa_FarmingOutputRateYearDesc"] = sheet.GetRow(1).GetCell(8).ToString().Trim().Replace("年", "");//農業產值成長率-資料年度(民國年)
                                row["Fa_FarmingOutputRate"] = sheet.GetRow(j).GetCell(8).ToString().Trim();//農業產值成長率-%
                                row["Fa_FarmerYear"] = sheet.GetRow(1).GetCell(9).ToString().Trim().Trim().Replace("年", "");//農戶人口數-資料年度(民國年)
                                row["Fa_Farmer"] = sheet.GetRow(j).GetCell(9).ToString().Trim();//農戶人口數-人
                                row["Fa_FarmEmploymentOutputValueYear"] = sheet.GetRow(1).GetCell(10).ToString().Trim().Replace("年", "");//平均農業從業人口產值-資料年度(民國年)
                                row["Fa_FarmEmploymentOutputValue"] = sheet.GetRow(j).GetCell(10).ToString().Trim();//平均農業從業人口產值-千元
                                row["Fa_CreateDate"] = dtNow;
                                row["Fa_CreateID"] = LogInfo.mGuid;//上傳者GUID
                                row["Fa_CreateName"] = LogInfo.name;//上傳者姓名
                                row["Fa_Status"] = "A";
                                row["Fa_Version"] = strMaxVersion;

                                if (chkYear == "")
                                    chkYear = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");

                                dt.Rows.Add(row);
                            }

                        }

                        if (dt.Rows.Count > 0)
                        {
                            strErrorMsg = "";
                            BeforeBulkCopy(oConn, myTrans, chkYear);//檢查資料表裡面是不是有該年的資料
                            DoBulkCopy(myTrans, dt, strErrorMsg);//匯入
                            myTrans.Commit();                   //最後再commit
                        }
                    }

                }
                catch (Exception ex)
                {
                    string Errormsg = ex.Message;
                    string[] eArray = Errormsg.Split(new string[] { "無法設定資料行", "。該值違反了這個資料行的 MaxLength 限制。", " ", "'" }, StringSplitOptions.None);
                    string ErrorField = eArray[3].ToString();
                    switch (ErrorField)
                    {
                        case "Fa_CityName":
                            strErrorMsg += "錯誤原因:城市名稱長度錯誤<br>";
                            break;

                        case "Fa_FarmingLossYear":
                            strErrorMsg += "欄位:臺閩地區農業天然災害產物損失-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Fa_FarmingLoss":
                            strErrorMsg += "欄位:臺閩地區農業天然災害產物損失<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出20位數";
                            break;

                        case "Fa_AnimalLossYear":
                            strErrorMsg += "欄位:天然災害畜牧業產物損失-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Fa_AnimalLoss":
                            strErrorMsg += "欄位:天然災害畜牧業產物損失<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出20位數";
                            break;

                        case "Fa_FishLossYear":
                            strErrorMsg += "欄位:天然災害漁業產物損失-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Fa_FishLoss":
                            strErrorMsg += "欄位:天然災害漁業產物損失<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料不可以超出20位數";
                            break;

                        case "Fa_ForestLossYear":
                            strErrorMsg += "欄位:臺閩地區林業天然災害產物損失-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Fa_ForestLoss":
                            strErrorMsg += "欄位:臺閩地區林業天然災害產物損失<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料不可以超出20位數";
                            break;

                        case "Fa_AllLossYear":
                            strErrorMsg += "欄位:農林漁牧天然災害產物損失-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Fa_AllLoss":
                            strErrorMsg += "欄位:農林漁牧天然災害產物損失<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出20位數";
                            break;

                        case "Fa_FacilityLossYear":
                            strErrorMsg += "欄位:農林漁牧天然災害設施(備)損失-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Fa_FacilityLoss":
                            strErrorMsg += "欄位:農林漁牧天然災害設施(備)損失<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出20位數";
                            break;

                        case "Fa_FarmingOutputValueYear":
                            strErrorMsg += "欄位:農業產值-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Fa_FarmingOutputValue":
                            strErrorMsg += "欄位:農業產<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料不可以超出20位數";
                            break;

                        case "Fa_FarmingOutputRateYearDesc":
                            strErrorMsg += "欄位:<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料不可以超出20位數";
                            break;

                        case "Fa_FarmingOutputRate":
                            strErrorMsg += "欄位:農業產值成長率-資料年度敘述<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出7位數";
                            break;

                        case "Fa_FarmerYear":
                            strErrorMsg += "欄位:農戶人口數-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Fa_Farmer":
                            strErrorMsg += "欄位:農戶人口數<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料不可以超出20位數";
                            break;

                        case "Fa_FarmEmploymentOutputValueYear":
                            strErrorMsg += "欄位:平均農業從業人口產值-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Fa_FarmEmploymentOutputValue":
                            strErrorMsg += "欄位:平均農業從業人口產值<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出20位數";
                            break;
                    }
                    myTrans.Rollback();
                }
                finally
                {
                    oCmd.Connection.Close();
                    oConn.Close();

                    /// Log
                    idl_db._IDL_Type = "ISTI";
                    idl_db._IDL_IP = Common.GetIPv4Address();
                    idl_db._IDL_Description = "檔案類別:農業 , 狀態：上傳成功";
                    idl_db._IDL_ModId = LogInfo.mGuid;
                    idl_db._IDL_ModName = LogInfo.name;
                    idl_db.addLog();

                    if (strErrorMsg == "")
                    {
                        Response.Write("<script type='text/JavaScript'>parent.feedbackFun('農業匯入成功');</script>");
                    }
                    else
                    {
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
                select @chkRowCount = count(*) from Farming where Fa_FarmingLossYear=@chkYear and Fa_Status='A'

                if @chkRowCount>0
                    begin
                        update Farming set Fa_Status='D' where Fa_FarmingLossYear=@chkYear and Fa_Status='A'
                    end
            ");
            SqlCommand oCmd = oConn.CreateCommand();
            oCmd.CommandText = sb.ToString();

            oCmd.Parameters.AddWithValue("@chkYear", chkYear);

            oCmd.Transaction = oTran;
            oCmd.ExecuteNonQuery();
        }

        //農業 BulkCopy
        private void DoBulkCopy(SqlTransaction oTran, DataTable srcData, string errorMsg)
        {
            SqlBulkCopyOptions setting = SqlBulkCopyOptions.CheckConstraints | SqlBulkCopyOptions.TableLock;
            using (SqlBulkCopy sqlBC = new SqlBulkCopy(oTran.Connection, setting, oTran))
            {
                sqlBC.BulkCopyTimeout = 600; ///設定逾時的秒數
                //sqlBC.BatchSize = 1000; ///設定一個批次量寫入多少筆資料, 設定值太小會影響效能 
                ////設定 NotifyAfter 屬性，以便在每複製 10000 個資料列至資料表後，呼叫事件處理常式。
                //sqlBC.NotifyAfter = 10000;
                ///設定要寫入的資料庫
                sqlBC.DestinationTableName = "Farming";

                /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
                sqlBC.ColumnMappings.Add("Fa_CityNo", "Fa_CityNo");
                sqlBC.ColumnMappings.Add("Fa_CityName", "Fa_CityName");
                sqlBC.ColumnMappings.Add("Fa_FarmingLossYear", "Fa_FarmingLossYear");
                sqlBC.ColumnMappings.Add("Fa_FarmingLoss", "Fa_FarmingLoss");
                sqlBC.ColumnMappings.Add("Fa_AnimalLossYear", "Fa_AnimalLossYear");
                sqlBC.ColumnMappings.Add("Fa_AnimalLoss", "Fa_AnimalLoss");
                sqlBC.ColumnMappings.Add("Fa_FishLossYear", "Fa_FishLossYear");
                sqlBC.ColumnMappings.Add("Fa_FishLoss", "Fa_FishLoss");
                sqlBC.ColumnMappings.Add("Fa_ForestLossYear", "Fa_ForestLossYear");
                sqlBC.ColumnMappings.Add("Fa_ForestLoss", "Fa_ForestLoss");
                sqlBC.ColumnMappings.Add("Fa_AllLossYear", "Fa_AllLossYear");
                sqlBC.ColumnMappings.Add("Fa_AllLoss", "Fa_AllLoss");
                sqlBC.ColumnMappings.Add("Fa_FacilityLossYear", "Fa_FacilityLossYear");
                sqlBC.ColumnMappings.Add("Fa_FacilityLoss", "Fa_FacilityLoss");
                sqlBC.ColumnMappings.Add("Fa_FarmingOutputValueYear", "Fa_FarmingOutputValueYear");
                sqlBC.ColumnMappings.Add("Fa_FarmingOutputValue", "Fa_FarmingOutputValue");
                sqlBC.ColumnMappings.Add("Fa_FarmingOutputRateYearDesc", "Fa_FarmingOutputRateYearDesc");
                sqlBC.ColumnMappings.Add("Fa_FarmingOutputRate", "Fa_FarmingOutputRate");
                sqlBC.ColumnMappings.Add("Fa_FarmerYear", "Fa_FarmerYear");
                sqlBC.ColumnMappings.Add("Fa_Farmer", "Fa_Farmer");
                sqlBC.ColumnMappings.Add("Fa_FarmEmploymentOutputValueYear", "Fa_FarmEmploymentOutputValueYear");
                sqlBC.ColumnMappings.Add("Fa_FarmEmploymentOutputValue", "Fa_FarmEmploymentOutputValue");
                sqlBC.ColumnMappings.Add("Fa_CreateDate", "Fa_CreateDate");
                sqlBC.ColumnMappings.Add("Fa_CreateID", "Fa_CreateID");
                sqlBC.ColumnMappings.Add("Fa_CreateName", "Fa_CreateName");
                sqlBC.ColumnMappings.Add("Fa_Status", "Fa_Status");
                sqlBC.ColumnMappings.Add("Fa_Version", "Fa_Version");

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