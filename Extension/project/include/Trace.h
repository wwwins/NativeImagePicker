#ifdef IPHONESIM

#define trace(c) NSLog(@"%s [Line %d] %s", __PRETTY_FUNCTION__, __LINE__, c)
#else
#define trace(...)

#endif
