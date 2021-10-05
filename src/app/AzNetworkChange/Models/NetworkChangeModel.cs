using System;
using System.Collections.Generic;

namespace AzNetworkChange.Models
{
  public class NetworkChangeModel
  {
    public List<NetworkChangeDetails> Value { get; set; }
  }

  public class NetworkChangeDetails
  {
    public string PartitionKey { get; set; }
    public string RowKey { get; set; }
    public DateTime Timestamp { get; set; }
    public string Operation { get; set; }
    public string Subscription { get; set; }
    public string ResourceId { get; set; }
    public string ChangedProperty { get; set; }
    public string ResourceType { get; set; }
    public string BeforeValue { get; set; }
    public string AfterValue { get; set; }
    public string ChangedBy { get; set; }
    public string RawPayload { get; set; }
    public DateTime time { get; set; }
    public DateTime DateTime { get; set; }

  }
}
