using namespace System.ComponentModel.DataAnnotations;
using namespace System.ComponentModel.DataAnnotations.Schema;

[Table('tenant')]
Class Tenant {
    [Key()]
    [StringLength(36)]
    [string]$ID
    
    [Required()]
    [StringLength(100)]
    [string]$Name
}

[Table('account_health')]
Class AccountHealth {
    [Key()]
    [StringLength(36)]
    [string]$ID

    [Required()]
    [StringLength(10000)]
    [string]$HealthRaw
}

[Table('endpoint')]
Class Endpoint {
    [Key()]
    [StringLength(36)]
    [string]$ID

    [StringLength(36)]
    [string]$TenantID

    [Required()]
    [StringLength(100)]
    [string]$Hostname

    [Required()]
    [StringLength(100)]
    [string]$HealthOverall

    [Required()]
    [StringLength(100)]
    [string]$HealthThreats

    [Required()]
    [StringLength(1000)]
    [string]$HealthThreatsRaw

    [Required()]
    [StringLength(100)]
    [string]$HealthServices

    [Required()]
    [StringLength(10000)]
    [string]$HealthServicesRaw

    [system.boolean]$TamperProtectionEnabled

    [Required()]
    [StringLength(100)]
    [string]$IsolationStatus

    [system.boolean]$IsolatedAdmin

    [system.boolean]$IsolatedSelf
}