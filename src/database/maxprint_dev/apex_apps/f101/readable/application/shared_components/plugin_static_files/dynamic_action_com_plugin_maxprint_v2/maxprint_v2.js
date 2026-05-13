let spinner_v2;

function show_spinner() {
    spinner_v2 = apex.util.showSpinner();
}

function hide_spinner() {
    if (spinner_v2) {
        spinner_v2.remove();
    }
}

function out_file_method(blob, file_name) {
    let url = blob;
    if (output_method == 'D') {
        let a = document.createElement("a");
        a.href = url;
        a.download = file_name;
        document.body.appendChild(a);
        a.click();
        a.remove();
    } else if (output_method == 'O') {
        let newtabwindow = window.open("");
        newtabwindow.document.open();
        newtabwindow.document.write("<iframe width='100%' height='100%' src='" + encodeURI(blob) + "'></iframe>");
        newtabwindow.document.close();
    } else if (output_method == 'P') {
        printJS({
            printable: blob.substr(blob.search('base64') + 7),
            type: 'pdf',
            base64: true
        });
    }
}

function redirectToReportBuilder(sqlData) {
    window.open(sqlData.redirect_url, '_blank');
}

function maxprint_render_v2() {
    x = this;
    ajax_identifier = x.action.ajaxIdentifier;
    pageitems_submit = x.action.attribute10;
    output_method = x.action.attribute13;

    // Show spinner_v2 
    if (pageitems_submit) {
        const searchRegExp = /\,/g;
        pageitems_submit = "#" + pageitems_submit.replace(searchRegExp, ",#");
    }
    // console.log(pageitems_submit)
    show_spinner();

    let maxprintCurrentConfig = x.action.attribute01 // Create = C, Edit = E, Run = R

    apex.server.plugin(
        ajax_identifier,
        {x01: "", pageItems: pageitems_submit,},
        {
            refreshObject: "",
            loadingIndicator: "",
            success: function (pData) 
                {
                    try {
                        console.log("Full PDATA", pData)
                        let f_file_mime_type = pData.mime_type;
                        let f_filename = pData.file_name;
                        let f_redirect_url = pData.redirect_url;
                        let f_file_base64;
                        if (pData.data) {

                            f_file_base64 = 'data:' + f_file_mime_type + ';base64,' + pData.data.replace(/['"]+/g, '');
                        }

                        if (maxprintCurrentConfig === 'C' || maxprintCurrentConfig === 'E') {
                            redirectToReportBuilder(pData);
                        } else {
                            out_file_method(f_file_base64, f_filename);

                        }

                        hide_spinner();
                }
                catch (ex) {
                    alert(ex.message)
                }
            },
            error: function (x) {
                apex.message.clearErrors();
                apex.message.showErrors([
                    {
                        type: "error",
                        location: "page",
                        message: x.responseText,
                        unsafe: false
                    }
                ]);
                hide_spinner();
            }
        }
    );
}