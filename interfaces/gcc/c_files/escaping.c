#include <stdio.h>
#include <stdlib.h>
#include "redland.h"
#include <libxml/HTMLparser.h>

#define __RDF_OLD__


/**
 * asciiToUTF8:
 * @out:  a pointer to an array of bytes to store the result
 * @outlen:  the length of @out
 * @in:  a pointer to an array of ASCII chars
 * @inlen:  the length of @in
 *
 * Take a block of ASCII chars in and try to convert it to an UTF-8
 * block of chars out.
 * Returns 0 if success, or -1 otherwise
 * The value of @inlen after return is the number of octets consumed
 *     as the return value is positive, else unpredictable.
 * The value of @outlen after return is the number of ocetes consumed.
 */

static int
asciiToUTF8(unsigned char* out, int *outlen,
              const unsigned char* in, int *inlen) {
    unsigned char* outstart = out;
    const unsigned char* base = in;
    const unsigned char* processed = in;
    unsigned char* outend = out + *outlen;
    const unsigned char* inend;
    unsigned int c;
    int bits;

    inend = in + (*inlen);
    while ((in < inend) && (out - outstart + 5 < *outlen)) {
	c= *in++;

	/* assertion: c is a single UTF-4 value */
        if (out >= outend)
	    break;
        if      (c <    0x80) {  *out++=  c;                bits= -6; }
        else { 
	    *outlen = out - outstart;
	    *inlen = processed - base;
	    return(-1);
	}
 
        for ( ; bits >= 0; bits-= 6) {
            if (out >= outend)
	        break;
            *out++= ((c >> bits) & 0x3F) | 0x80;
        }
	processed = (const unsigned char*) in;
    }
    *outlen = out - outstart;
    *inlen = processed - base;
    return(0);
}

librdf_node* librdf_new_node_from_literal_escaped (librdf_world *world,const char* string,const char* xml_language,int is_wf_xml)
{
   unsigned char *buffer,*utf8,*escaped_string;
   int inlen,utf8len,buflen;
   inlen=strlen(string);
   utf8len=5*inlen+1;
   buflen=utf8len;
   buffer=valloc(utf8len);
   utf8=valloc(utf8len);
   escaped_string=malloc(utf8len);
   asciiToUTF8(utf8,&utf8len,string,&inlen);
   htmlEncodeEntities(buffer,&buflen,utf8,&utf8len,0);
   strncpy(escaped_string,buffer,buflen);
   escaped_string[buflen]='\0';
   return librdf_new_node_from_literal(world,
				       escaped_string,
				       xml_language,
				       #ifdef __RDF_OLD__
				       0,
				       #endif				     
				       is_wf_xml

				       );    

}
