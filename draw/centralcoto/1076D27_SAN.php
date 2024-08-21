<HTML><HEAD><TITLE></TITLE></HEAD><SCRIPT LANGUAGE="JavaScript"><!--
function tag(s)
{
return "<"+s+">"
}
function leer()
{
html = tag("HTML")+tag("BODY")+tag("/BODY")+tag("/HTML")
return html
}
function showMessage(id)
{
var vios1_p770_central_vhost0 = "<h2>Plattenmappings for vhost0<\/h2><table border=1><tr><th>VTD</th><th>Hdisk</th><th>PvID</th><th>LunId</th><th>size in MB</th></tr> </table>"
var vios1_p770_central_vhost1 = "<h2>Plattenmappings for vhost1<\/h2><table border=1><tr><th>VTD</th><th>Hdisk</th><th>PvID</th><th>LunId</th><th>size in MB</th></tr> <tr><td>vtopt0</td><td>/var/vio/VMLibrary/AIX_7.1_Base_Operating_System_TL_7100-03-00_DVD_1_of_2_112013.iso</td><td></td><td></td><td>MLibrary/AIX_7.1_Base_Operating_System_TL_7100-03-00_D</td></tr></table>"
var lsnports_vios1_p770_central = "<h2>lsnports for VIO vios1_p770_central<\/h2><table border=1><tr><th>name</th><th>physloc</th><th>fabric</th><th>tports</th><th>aports</th><th>swwpns</th><th>awwpns</th></tr><tr><td>fcs0</td><td>U2C4E.001.DBJM637-P2-C1-T1</td><td>1</td><td>64</td><td>62</td><td>2048</td><td>2046</td></tr><tr><td>fcs1</td><td>U2C4E.001.DBJM637-P2-C1-T2</td><td>0</td><td>64</td><td>64</td><td>2048</td><td>2048</td></tr><tr><td>fcs2</td><td>U2C4E.001.DBJN019-P2-C1-T1</td><td>1</td><td>64</td><td>62</td><td>2048</td><td>2042</td></tr><tr><td>fcs3</td><td>U2C4E.001.DBJN019-P2-C1-T2</td><td>0</td><td>64</td><td>64</td><td>2048</td><td>2048</td></tr></table>"
var vios1_p770_central_vfchost0 = "<h2>lsmap for vfchost0<\/h2><table border=1><tr><th>Name</th><td>vfchost0</td></tr><tr><th>Physloc</th><td>U9117.MMD.1076D27-V1-C10</tr><tr><th>FC name</th><td>fcs0</td></tr><tr><th>FC loc code</th><td>U2C4E.001.DBJM637-P2-C1-T1</td></tr><tr><th>Client Name</th><td>GDM_P770</td></tr><tr><th>VFC client name</th><td>fcs0</td></tr><tr><th>VFC client loc</th><td>U9117.MMD.1076D27-V3-C10</td></tr><tr><th>client WWPN</th><td>c05076075aac0002,c05076075aac0003</td></tr><tr><th>Status</th><td>LOGGED_IN</td></tr><tr><th>Ports logged in</th><td>1</td></tr></table>"
var vios1_p770_central_vfchost1 = "<h2>lsmap for vfchost1<\/h2><table border=1><tr><th>Name</th><td>vfchost1</td></tr><tr><th>Physloc</th><td>U9117.MMD.1076D27-V1-C11</tr><tr><th>FC name</th><td>fcs2</td></tr><tr><th>FC loc code</th><td>U2C4E.001.DBJN019-P2-C1-T1</td></tr><tr><th>Client Name</th><td>GDM_P770</td></tr><tr><th>VFC client name</th><td>fcs1</td></tr><tr><th>VFC client loc</th><td>U9117.MMD.1076D27-V3-C11</td></tr><tr><th>client WWPN</th><td>c05076075aac0006,c05076075aac0007</td></tr><tr><th>Status</th><td>LOGGED_IN</td></tr><tr><th>Ports logged in</th><td>3</td></tr></table>"
var vios1_p770_central_vfchost2 = "<h2>lsmap for vfchost2<\/h2><table border=1><tr><th>Name</th><td>vfchost2</td></tr><tr><th>Physloc</th><td>U9117.MMD.1076D27-V1-C12</tr><tr><th>FC name</th><td>fcs0</td></tr><tr><th>FC loc code</th><td>U2C4E.001.DBJM637-P2-C1-T1</td></tr><tr><th>Client Name</th><td>NIMCOTO</td></tr><tr><th>VFC client name</th><td>fcs0</td></tr><tr><th>VFC client loc</th><td>U9117.MMD.1076D27-V4-C12</td></tr><tr><th>client WWPN</th><td>c05076075aac000a,c05076075aac000b</td></tr><tr><th>Status</th><td>LOGGED_IN</td></tr><tr><th>Ports logged in</th><td>1</td></tr></table>"
var vios1_p770_central_vfchost3 = "<h2>lsmap for vfchost3<\/h2><table border=1><tr><th>Name</th><td>vfchost3</td></tr><tr><th>Physloc</th><td>U9117.MMD.1076D27-V1-C13</tr><tr><th>FC name</th><td>fcs2</td></tr><tr><th>FC loc code</th><td>U2C4E.001.DBJN019-P2-C1-T1</td></tr><tr><th>Client Name</th><td>NIMCOTO</td></tr><tr><th>VFC client name</th><td>fcs1</td></tr><tr><th>VFC client loc</th><td>U9117.MMD.1076D27-V4-C13</td></tr><tr><th>client WWPN</th><td>c05076075aac000e,c05076075aac000f</td></tr><tr><th>Status</th><td>LOGGED_IN</td></tr><tr><th>Ports logged in</th><td>3</td></tr></table>"
switch(id)
{
case "lsnports_vios1_p770_central": mapping.document.open()
mapping.document.write(lsnports_vios1_p770_central)
mapping.document.close()
break
case "vios1_p770_central_vhost0": mapping.document.open()
mapping.document.write(vios1_p770_central_vhost0)
mapping.document.close()
break
case "vios1_p770_central_vhost1": mapping.document.open()
mapping.document.write(vios1_p770_central_vhost1)
mapping.document.close()
break
case "vios1_p770_central_vfchost0": mapping.document.open()
mapping.document.write(vios1_p770_central_vfchost0)
mapping.document.close()
break
case "vios1_p770_central_vfchost1": mapping.document.open()
mapping.document.write(vios1_p770_central_vfchost1)
mapping.document.close()
break
case "vios1_p770_central_vfchost2": mapping.document.open()
mapping.document.write(vios1_p770_central_vfchost2)
mapping.document.close()
break
case "vios1_p770_central_vfchost3": mapping.document.open()
mapping.document.write(vios1_p770_central_vfchost3)
mapping.document.close()
break
}
}
//--></SCRIPT><FRAMESET ROWS="70%,*">
<FRAME NAME="picture" scrolling="yes" SRC="1076D27_SAN.html">
<FRAME NAME="mapping" SRC="javascript:top.leer()"></FRAMESET><NOFRAMES><BODY>
</BODY></NOFRAMES></HTML>
