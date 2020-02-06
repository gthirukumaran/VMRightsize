Function Enable-MemHotAdd($vm){
    $vmview = Get-vm $vm | Get-View 
    $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec

    $extra = New-Object VMware.Vim.optionvalue
    $extra.Key="mem.hotadd"
    $extra.Value="true"
    $vmConfigSpec.extraconfig += $extra

    $vmview.ReconfigVM($vmConfigSpec)
}

Function Enable-vCpuHotAdd($vm){
    $vmview = Get-vm $vm | Get-View 
    $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec

    $extra = New-Object VMware.Vim.optionvalue
    $extra.Key="vcpu.hotadd"
    $extra.Value="true"
    $vmConfigSpec.extraconfig += $extra

    $vmview.ReconfigVM($vmConfigSpec)
}
 

$vmlist = Import-CSV C:\csvfile.csv

 
foreach ($item in $vmlist) {
    $vmname = $item.vmname
    Stop-VM -VM $vmname -RunAsync 
    }
foreach ($item in $vmlist) {

    $vmname = $item.vmname
    $cpu = $item.cpu
    $mem = [int]$item.mem * 1024
    Enable-MemHotAdd $vmname
    Enable-vCpuHotAdd $vmname
    Set-VM -VM $vmname -NumCpu $cpu -MemoryMB $mem -RunAsync -Confirm:$false

}

foreach ($item in $vmlist) {
    $vmname = $item.vmname
    Start-VM -VM $vmname -RunAsync 
    }
