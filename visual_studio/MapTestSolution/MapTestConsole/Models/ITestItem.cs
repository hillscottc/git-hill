using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole.Models
{
    interface ITestItem
    {
        int Id { get; set; }
        string Address { get; set; }
        int CampaignId { get; set; }
        int ResellerId { get; set; }

    }
}
