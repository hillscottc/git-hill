using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.Models
{
    public partial class ResultModelContainer
    {
        public void SaveTestItems(IList<TestItem> testItems)
        {
            foreach(TestItem testItem in testItems)
            {
                this.TestItems.Add(testItem);
                this.SaveChanges();
            }
        }

        //public void SaveVendorTestResults(IList<VendorTestResult> testResults)
        //{
        //    foreach (VendorTestResult testResult in testResults)
        //    {
        //        //engine1.Manufacturer = context.Manufacturers.Single(m => m.Name == engine1.Manufacturer.Name);
                
        //        // avoid a dup here ?
        //        //testResult.Vendor = this.Vendors.Single(v => v.Id == testResult.Vendor.Id);

        //        this.VendorTestResults.Add(testResult);
        //        this.SaveChanges();
        //    }
        //}

        public void SaveDistanceResults(IList<DistanceResult> distanceResults)
        {
            foreach (DistanceResult dr in distanceResults)
            {
                this.DistanceResults.Add(dr);
                this.SaveChanges();
            }
        }



    }

}
