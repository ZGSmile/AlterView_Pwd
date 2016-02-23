
#define SingletonInterface(Class) +(instancetype)shared##Class;

#if __has_feature(objc_arc)

// ARC
#define SingletonImplementation(Class) \
static Class *_instance; \
+(instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+(instancetype)shared##Class \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
-(id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

#else

// MRC
#define SingletonImplementation(Class) \
static Class *_instance; \
+(instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+(instancetype)shared##Class \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
-(id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
} \
- (oneway void)release{} \
- (instancetype)retain{return _instance;} \
- (instancetype)autorelease{return _instance;} \
- (NSUInteger)retainCount{return ULONG_MAX;}

#endif
