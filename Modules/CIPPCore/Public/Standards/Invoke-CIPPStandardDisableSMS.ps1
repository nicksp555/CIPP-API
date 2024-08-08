function Invoke-CIPPStandardDisableSMS {
    <#
    .FUNCTIONALITY
        Internal
    .COMPONENT
        (APIName) DisableSMS
    .SYNOPSIS
        (Label) Disables SMS as an MFA method
    .DESCRIPTION
        (Helptext) This blocks users from using SMS as an MFA method. If a user only has SMS as a MFA method, they will be unable to log in.
        (DocsDescription) Disables SMS as an MFA method for the tenant. If a user only has SMS as a MFA method, they will be unable to sign in.
    .NOTES
        CAT
            Entra (AAD) Standards
        TAG
            "highimpact"
        ADDEDCOMPONENT
        IMPACT
            High Impact
        POWERSHELLEQUIVALENT
            Update-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration
        RECOMMENDEDBY
        UPDATECOMMENTBLOCK
            Run the Tools\Update-StandardsComments.ps1 script to update this comment block
    .LINK
        https://docs.cipp.app/user-documentation/tenant/standards/edit-standards
    #>

    param($Tenant, $Settings)
    #$Rerun = Test-CIPPRerun -Type Standard -Tenant $Tenant -Settings $Settings 'DisableSMS'

    $CurrentInfo = New-GraphGetRequest -Uri 'https://graph.microsoft.com/beta/policies/authenticationmethodspolicy/authenticationMethodConfigurations/SMS' -tenantid $Tenant
    $State = if ($CurrentInfo.state -eq 'enabled') { $true } else { $false }

    If ($Settings.remediate -eq $true) {
        if ($State) {
            Set-CIPPAuthenticationPolicy -Tenant $tenant -APIName 'Standards' -AuthenticationMethodId 'SMS' -Enabled $false
        } else {
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'SMS authentication method is already disabled.' -sev Info
        }
    }

    if ($Settings.alert -eq $true) {
        if ($State) {
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'SMS authentication method is enabled' -sev Alert
        } else {
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'SMS authentication method is not enabled' -sev Info
        }
    }

    if ($Settings.report -eq $true) {
        Add-CIPPBPAField -FieldName 'DisableSMS' -FieldValue $State -StoreAs bool -Tenant $tenant
    }
}
