    using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.Models
{
    public partial class TestItem 
    {
        public static IList<TestItem> GetTestItems(IList<Models.vwMapTest> rawAddresses)
        {
            IList<TestItem> testItems = new List<TestItem>();

            foreach (vwMapTest rawAddress in rawAddresses)
            {
                using (var dbTest = new ResultModelContainer())
                {
                    // create a test item from the raw address
                    var testItem = new TestItem
                    {
                        Address = GeoMapUtil.GetLocationString(rawAddress.City, rawAddress.Region, rawAddress.PostalCode),
                        ResellerId = rawAddress.ResellerID
                    };

                    testItems.Add(testItem);
                }
            }

            return testItems;
        }

        public override string ToString()
        {
            return String.Format("Id:{0}; cId:{1}; rId:{2}; Address:{3}", Id, CampaignId, ResellerId, Address);
        }


    }
}
