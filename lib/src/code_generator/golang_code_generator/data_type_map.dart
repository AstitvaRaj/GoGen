const returnDataTypes = {'string':'*C.char','int':'*C.int'};

const paramDataTypes = {'string':'*C.char','int':'C.int'};

const goToCDataType = {'string':'C.CString','int':'C.int'};

const cToGoDataType = {'C.CString':'C.GoString','*C.char':'C.GoString','C.int':'int','string' : 'C.GoString'};