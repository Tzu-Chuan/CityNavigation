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
    public partial class ImportSafety : System.Web.UI.Page
    {
        Safety_DB SF_DB = new Safety_DB();
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
                dt.Columns.Add("Sf_CityNo", typeof(string)).MaxLength = 2;
                dt.Columns.Add("Sf_CityName", typeof(string)).MaxLength = 10;
                dt.Columns.Add("Sf_SoilAreaYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Sf_SoilArea", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Sf_UnderWaterAreaYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Sf_UnderWaterArea", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Sf_PM25QuantityYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Sf_PM25Quantity", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Sf_10KPeopleFireTimesYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Sf_10KPeopleFireTimes", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Sf_100KPeopleBurglaryTimesYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Sf_100KPeopleBurglaryTimes", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Sf_BurglaryClearanceRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Sf_BurglaryClearanceRate", typeof(string)).MaxLength = 7;
                dt.Columns.Add("Sf_100KPeopleCriminalCaseTimesYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Sf_100KPeopleCriminalCaseTimes", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Sf_CriminalCaseClearanceRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Sf_CriminalCaseClearanceRate", typeof(string)).MaxLength = 7;
                dt.Columns.Add("Sf_100KPeopleViolentCrimesTimesYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Sf_100KPeopleViolentCrimesTimes", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Sf_ViolentCrimesClearanceRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Sf_ViolentCrimesClearanceRate", typeof(string)).MaxLength = 7;
                dt.Columns.Add("Sf_CreateDate", typeof(DateTime));
                dt.Columns.Add("Sf_CreateID", typeof(string));
                dt.Columns.Add("Sf_CreateName", typeof(string));
                dt.Columns.Add("Sf_Status", typeof(string));
                dt.Columns.Add("Sf_Version", typeof(int));

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

                        //簡易判斷這份Excel是不是安全的Excel
                        int cellsCount = sheet.GetRow(0).Cells.Count;
                        //1.判斷表頭欄位數
                        if (cellsCount != 11)
                        {
                            throw new Exception("請檢查是否為安全的匯入檔案");
                        }
                        //2.檢查欄位名稱
                        if (sheet.GetRow(0).GetCell(1).ToString().Trim() != "土壤污染控制場址面積" || sheet.GetRow(0).GetCell(2).ToString().Trim() != "地下水受污染使用限制面積")
                        {
                            throw new Exception("請檢查是否為安全的匯入檔案");
                        }

                        //取得當前最大版次 (+1變成現在版次)
                        strMaxVersion = SF_DB.getMaxVersin() + 1;

                        //取得代碼檔
                        CodeTable_DB code_db = new CodeTable_DB();
                        DataTable dtCode = code_db.getCommonCode("02");

                        string cityNo = string.Empty;

                        //資料從第四筆開始 最後一筆是合計不進資料庫
                        for (int j = 3; j < sheet.PhysicalNumberOfRows - 2; j++)
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
                                row["Sf_CityNo"] = cityNo;//縣市代碼
                                row["Sf_CityName"] = sheet.GetRow(j).GetCell(0).ToString().Trim();//縣市名稱
                                row["Sf_SoilAreaYear"] = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");//土壤污染控制場址面積-資料年度(民國年)
                                row["Sf_SoilArea"] = sheet.GetRow(j).GetCell(1).ToString().Trim();//土壤污染控制場址面積-平方公尺
                                row["Sf_UnderWaterAreaYear"] = sheet.GetRow(1).GetCell(2).ToString().Trim().Replace("年", "");//地下水受污染使用限制面積-資料年度(民國年)
                                row["Sf_UnderWaterArea"] = sheet.GetRow(j).GetCell(2).ToString().Trim();//地下水受污染使用限制面積-平方公尺
                                row["Sf_PM25QuantityYear"] = sheet.GetRow(1).GetCell(3).ToString().Trim().Replace("年", "");//總懸浮微粒排放量-資料年度(民國年)
                                row["Sf_PM25Quantity"] = sheet.GetRow(j).GetCell(3).ToString().Trim();//總懸浮微粒排放量-公噸
                                row["Sf_10KPeopleFireTimesYear"] = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");//每萬人火災發生次數-資料年度(民國年)
                                row["Sf_10KPeopleFireTimes"] = sheet.GetRow(j).GetCell(4).ToString().Trim();//每萬人火災發生次數-次
                                row["Sf_100KPeopleBurglaryTimesYear"] = sheet.GetRow(1).GetCell(5).ToString().Trim().Replace("年", "");//每十萬人竊盜案發生數-資料年度(民國年)
                                row["Sf_100KPeopleBurglaryTimes"] = sheet.GetRow(j).GetCell(5).ToString().Trim();//每十萬人竊盜案發生數-件
                                row["Sf_BurglaryClearanceRateYear"] = sheet.GetRow(1).GetCell(6).ToString().Trim().Replace("年", "");//竊盜案破獲率-資料年度(民國年)
                                row["Sf_BurglaryClearanceRate"] = sheet.GetRow(j).GetCell(6).ToString().Trim();//竊盜案破獲率-%
                                row["Sf_100KPeopleCriminalCaseTimesYear"] = sheet.GetRow(1).GetCell(7).ToString().Trim().Replace("年", "");//每十萬人刑案發生數-資料年度(民國年)
                                row["Sf_100KPeopleCriminalCaseTimes"] = sheet.GetRow(j).GetCell(7).ToString().Trim();//每十萬人刑案發生數-件
                                row["Sf_CriminalCaseClearanceRateYear"] = sheet.GetRow(1).GetCell(8).ToString().Trim().Replace("年", "");//刑案破獲率-資料年度(民國年)
                                row["Sf_CriminalCaseClearanceRate"] = sheet.GetRow(j).GetCell(8).ToString().Trim();//刑案破獲率-%
                                row["Sf_100KPeopleViolentCrimesTimesYear"] = sheet.GetRow(1).GetCell(9).ToString().Trim().Replace("年", "");//每十萬人暴力犯罪發生數-資料年度(民國年)
                                row["Sf_100KPeopleViolentCrimesTimes"] = sheet.GetRow(j).GetCell(9).ToString().Trim();//每十萬人暴力犯罪發生數-件
                                row["Sf_ViolentCrimesClearanceRateYear"] = sheet.GetRow(1).GetCell(10).ToString().Trim().Replace("年", "");//暴力犯罪破獲率-資料年度(民國年)
                                row["Sf_ViolentCrimesClearanceRate"] = sheet.GetRow(j).GetCell(10).ToString().Trim();//暴力犯罪破獲率-%
                                row["Sf_CreateDate"] = dtNow;
                                row["Sf_CreateID"] = LogInfo.mGuid;//上傳者GUID
                                row["Sf_CreateName"] = LogInfo.name;//上傳者姓名
                                row["Sf_Status"] = "A";
                                row["Sf_Version"] = strMaxVersion;

                                if (chkYear == "")
                                    chkYear = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");

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
                        case "Sf_CityName":
                            strErrorMsg += "錯誤原因:城市名稱長度錯誤<br>";
                            break;

                        case "Sf_SoilAreaYear":
                            strErrorMsg += "欄位:土壤污染控制場址面積-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Sf_SoilArea":
                            strErrorMsg += "欄位:土壤污染控制場址面積<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料不可以超出20位數";
                            break;

                        case "Sf_UnderWaterAreaYear":
                            strErrorMsg += "欄位:地下水受污染使用限制面積-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Sf_UnderWaterArea":
                            strErrorMsg += "欄位:地下水受污染使用限制面積<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出20位數";
                            break;

                        case "Sf_PM25QuantityYear":
                            strErrorMsg += "欄位:總懸浮微粒排放量-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Sf_PM25Quantity":
                            strErrorMsg += "欄位:總懸浮微粒排放量<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出20位數";
                            break;

                        case "Sf_10KPeopleFireTimesYear":
                            strErrorMsg += "欄位:每萬人火災發生次數-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Sf_10KPeopleFireTimes":
                            strErrorMsg += "欄位:每萬人火災發生次數<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出20位數";
                            break;

                        case "Sf_100KPeopleBurglaryTimesYear":
                            strErrorMsg += "欄位:每十萬人竊盜案發生數-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Sf_100KPeopleBurglaryTimes":
                            strErrorMsg += "欄位:每十萬人竊盜案發生數<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出20位數";
                            break;

                        case "Sf_BurglaryClearanceRateYear":
                            strErrorMsg += "欄位:竊盜案破獲率-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Sf_BurglaryClearanceRate":
                            strErrorMsg += "欄位:竊盜案破獲率<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出7位數";
                            break;

                        case "Sf_100KPeopleCriminalCaseTimesYear":
                            strErrorMsg += "欄位:每十萬人刑案發生數-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Sf_100KPeopleCriminalCaseTimes":
                            strErrorMsg += "欄位:每十萬人刑案發生數<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出20位數";
                            break;

                        case "Sf_CriminalCaseClearanceRateYear":
                            strErrorMsg += "欄位:刑案破獲率-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Sf_CriminalCaseClearanceRate":
                            strErrorMsg += "欄位:刑案破獲率<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出7位數";
                            break;

                        case "Sf_100KPeopleViolentCrimesTimesYear":
                            strErrorMsg += "欄位:每十萬人暴力犯罪發生數-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Sf_100KPeopleViolentCrimesTimes":
                            strErrorMsg += "欄位:每十萬人暴力犯罪發生數<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出20位數";
                            break;

                        case "Sf_ViolentCrimesClearanceRateYear":
                            strErrorMsg += "欄位:暴力犯罪破獲率-資料年度<br>";
                            strErrorMsg += "錯誤原因:年分不可以超出3位數";
                            break;

                        case "Sf_ViolentCrimesClearanceRate":
                            strErrorMsg += "欄位:暴力犯罪破獲率<br>";
                            strErrorMsg += "錯誤原因:儲存格內資料包含小數點不可以超出7位數";
                            break;
                    }
                    myTrans.Rollback();
                }
                finally
                {
                    oCmd.Connection.Close();
                    oConn.Close();
                    if (strErrorMsg == "")
                    {
                        Response.Write("<script type='text/JavaScript'>parent.feedbackFun('安全匯入成功');</script>");
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
                select @chkRowCount = count(*) from Safety where Sf_SoilAreaYear=@chkYear and Sf_Status='A'

                if @chkRowCount>0
                    begin
                        update Safety set Sf_Status='D' where Sf_SoilAreaYear=@chkYear and Sf_Status='A'
                    end
            ");
            SqlCommand oCmd = oConn.CreateCommand();
            oCmd.CommandText = sb.ToString();

            oCmd.Parameters.AddWithValue("@chkYear", chkYear);

            oCmd.Transaction = oTran;
            oCmd.ExecuteNonQuery();
        }

        //安全 BulkCopy
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
                sqlBC.DestinationTableName = "Safety";

                /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
                sqlBC.ColumnMappings.Add("Sf_CityNo", "Sf_CityNo");
                sqlBC.ColumnMappings.Add("Sf_CityName", "Sf_CityName");
                sqlBC.ColumnMappings.Add("Sf_SoilAreaYear", "Sf_SoilAreaYear");
                sqlBC.ColumnMappings.Add("Sf_SoilArea", "Sf_SoilArea");
                sqlBC.ColumnMappings.Add("Sf_UnderWaterAreaYear", "Sf_UnderWaterAreaYear");
                sqlBC.ColumnMappings.Add("Sf_UnderWaterArea", "Sf_UnderWaterArea");
                sqlBC.ColumnMappings.Add("Sf_PM25QuantityYear", "Sf_PM25QuantityYear");
                sqlBC.ColumnMappings.Add("Sf_PM25Quantity", "Sf_PM25Quantity");
                sqlBC.ColumnMappings.Add("Sf_10KPeopleFireTimesYear", "Sf_10KPeopleFireTimesYear");
                sqlBC.ColumnMappings.Add("Sf_10KPeopleFireTimes", "Sf_10KPeopleFireTimes");
                sqlBC.ColumnMappings.Add("Sf_100KPeopleBurglaryTimesYear", "Sf_100KPeopleBurglaryTimesYear");
                sqlBC.ColumnMappings.Add("Sf_100KPeopleBurglaryTimes", "Sf_100KPeopleBurglaryTimes");
                sqlBC.ColumnMappings.Add("Sf_BurglaryClearanceRateYear", "Sf_BurglaryClearanceRateYear");
                sqlBC.ColumnMappings.Add("Sf_BurglaryClearanceRate", "Sf_BurglaryClearanceRate");
                sqlBC.ColumnMappings.Add("Sf_100KPeopleCriminalCaseTimesYear", "Sf_100KPeopleCriminalCaseTimesYear");
                sqlBC.ColumnMappings.Add("Sf_100KPeopleCriminalCaseTimes", "Sf_100KPeopleCriminalCaseTimes");
                sqlBC.ColumnMappings.Add("Sf_CriminalCaseClearanceRateYear", "Sf_CriminalCaseClearanceRateYear");
                sqlBC.ColumnMappings.Add("Sf_CriminalCaseClearanceRate", "Sf_CriminalCaseClearanceRate");
                sqlBC.ColumnMappings.Add("Sf_100KPeopleViolentCrimesTimesYear", "Sf_100KPeopleViolentCrimesTimesYear");
                sqlBC.ColumnMappings.Add("Sf_100KPeopleViolentCrimesTimes", "Sf_100KPeopleViolentCrimesTimes");
                sqlBC.ColumnMappings.Add("Sf_ViolentCrimesClearanceRateYear", "Sf_ViolentCrimesClearanceRateYear");
                sqlBC.ColumnMappings.Add("Sf_ViolentCrimesClearanceRate", "Sf_ViolentCrimesClearanceRate");
                sqlBC.ColumnMappings.Add("Sf_CreateDate", "Sf_CreateDate");
                sqlBC.ColumnMappings.Add("Sf_CreateID", "Sf_CreateID");
                sqlBC.ColumnMappings.Add("Sf_CreateName", "Sf_CreateName");
                sqlBC.ColumnMappings.Add("Sf_Status", "Sf_Status");
                sqlBC.ColumnMappings.Add("Sf_Version", "Sf_Version");

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