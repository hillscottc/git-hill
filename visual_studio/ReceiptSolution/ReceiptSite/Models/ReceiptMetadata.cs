using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;


namespace ReceiptSite.Models
{
    // This blank partial class exists only to add the Metadata.
    [MetadataType(typeof(ReceiptMetadata))]
    public partial class Receipt { }

    public class ReceiptMetadata
    {
        [Required]
        public int id { get; set; }

        [Required]
        public string Name { get; set; }

        [DisplayName("The text to write")]
        public string TextData { get; set; }

        [Required]
        [DisplayName("Modified image")]
        public Nullable<int> ReceiptImageId { get; set; }

        [Required]
        [DisplayName("Blank image")]
        public Nullable<int> BlankImageId { get; set; }

        [Required]
        public Nullable<bool> Active { get; set; }

        [Required]
        public Nullable<System.DateTime> CreateDate { get; set; }

    }
}