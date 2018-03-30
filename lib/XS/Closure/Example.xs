#ifdef __cplusplus
extern "C" {
#endif

#define PERL_NO_GET_CONTEXT /* we want efficiency */
#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#ifdef __cplusplus
} /* extern "C" */
#endif

#define NEED_newSVpvn_flags
#include "ppport.h"

#define IsArrayRef(sv) (SvROK(sv) && !SvOBJECT(SvRV(sv)) && SvTYPE(SvRV(sv)) == SVt_PVAV)
#define IsHashRef(sv) (SvROK(sv) && !SvOBJECT(SvRV(sv)) && SvTYPE(SvRV(sv)) == SVt_PVHV)
#define IsCodeRef(sv) (SvROK(sv) && !SvOBJECT(SvRV(sv)) && SvTYPE(SvRV(sv)) == SVt_PVCV)
#define WANT_ARRAY GIMME_V == G_ARRAY

static void
push_values(pTHX_ SV *retval)
{
    dSP;
    if (WANT_ARRAY && IsArrayRef(retval)) {
        AV *av  = (AV *)SvRV(retval);
        I32 len = av_len(av) + 1;
        EXTEND(SP, len);
        for (I32 i = 0; i < len; i++){
            SV **const svp = av_fetch(av, i, FALSE);
            PUSHs(svp ? *svp : &PL_sv_undef);
        }
    } else if (WANT_ARRAY && IsHashRef(retval)) {
        HV *hv = (HV *)SvRV(retval);
        HE *he;
        hv_iterinit(hv);
        while ((he = hv_iternext(hv)) != NULL){
            EXTEND(SP, 2);
            PUSHs(hv_iterkeysv(he));
            PUSHs(hv_iterval(hv, he));
        }
    } else {
        XPUSHs(retval ? retval : &PL_sv_undef);
    }
    PUTBACK;
}

XS(XS_prototype_getter)
{
    dVAR; dXSARGS;
    SV *retval = (SV *)CvXSUBANY(cv).any_ptr;
    SP -= items; /* PPCODE */
    PUTBACK;
    push_values(aTHX_ retval);
}

static void
anon_subroutine(pTHX_ CV *cv)
{
    dVAR; dXSARGS;
    SV *retval = (SV *)CvXSUBANY(cv).any_ptr;
    SP -= items; /* PPCODE */
    PUTBACK;
    push_values(aTHX_ retval);
}

MODULE = XS::Closure::Example    PACKAGE = XS::Closure::Example

PROTOTYPES: DISABLE

CV *
make_closure(retval)
    SV *retval
PREINIT:
    CV *xsub;
CODE:
{
    xsub = newXS(NULL /* anonymous */, XS_prototype_getter, __FILE__);
    CvXSUBANY(xsub).any_ptr = (void *)retval;
    RETVAL = xsub;
}
OUTPUT:
    RETVAL

CV *
make_closure_c(retval)
    SV *retval
PREINIT:
    CV *cv;
CODE:
{
    cv = (CV *)newSV(0);
    sv_upgrade((SV *)cv, SVt_PVCV);
    CvISXSUB_on(cv);
    CvXSUB(cv) = anon_subroutine;
    CvXSUBANY(cv).any_ptr = (void *)retval;
    CvFILE(cv) = __FILE__;
    RETVAL = cv;
}
OUTPUT:
    RETVAL

