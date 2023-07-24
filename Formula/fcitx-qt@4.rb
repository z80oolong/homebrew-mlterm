class FcitxQtAT4 < Formula
  desc "Multi-platform C++ GUI application framework"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/archive/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz"
  sha256 "e2882295097e47fe089f8ac741a95fef47e0a73a3f3cdf21b56990638f626ea0"

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "libxml2"
  depends_on "pulseaudio"
  depends_on "dbus"
  depends_on "dbus-glib"
  depends_on "mysql@5.7"
  depends_on "sqlite"
  depends_on "postgresql@10"
  depends_on "libiodbc"

  patch :p1, :DATA

  def install
    args = %W[
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -fast
      -system-libjpeg -system-libpng -system-zlib
      -qt-libtiff
      -qt-libmng
      -qt-libtiff
      -qt-zlib
      -plugin-sql-mysql
      -plugin-sql-odbc
      -plugin-sql-psql
      -plugin-sql-sqlite
      -no-webkit
      -no-phonon
      -no-phonon-backend
      -no-script
      -no-scripttools
      -no-qt3support
      -no-multimedia
      -no-xmlpatterns
      -no-sql-sqlite2
      -no-nis
      -no-cups
      -no-iconv
      -no-pch
      -no-separate-debug-info
      -no-3dnow
      -no-avx
      -no-sse
      -no-sse2
      -no-sse3
      -no-ssse3
      -no-sse4.1
      -no-sse4.2
      -no-gtkstyle
      -no-nas-sound
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += hello.cpp
    EOS

    (testpath/"hello.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
          QCoreApplication a(argc, argv);
          qDebug() << "Hello, world!";
          return 0;
      }
    EOS

    system "#{bin}/qmake", "hello.pro"
    system "make"
    assert_equal "Hello, world!\n", shell_output("./hello").chomp
  end
end

__END__
diff --git a/src/3rdparty/webkit/Source/WebCore/html/HTMLImageElement.cpp b/src/3rdparty/webkit/Source/WebCore/html/HTMLImageElement.cpp
index d66075e4..fe7518b2 100644
--- a/src/3rdparty/webkit/Source/WebCore/html/HTMLImageElement.cpp
+++ b/src/3rdparty/webkit/Source/WebCore/html/HTMLImageElement.cpp
@@ -74,7 +74,11 @@ PassRefPtr<HTMLImageElement> HTMLImageElement::createForJSConstructor(Document*
     RefPtr<HTMLImageElement> image = adoptRef(new HTMLImageElement(imgTag, document));
     if (optionalWidth)
         image->setWidth(*optionalWidth);
+#if 0
     if (optionalHeight > 0)
+#else
+    if (optionalHeight)
+#endif
         image->setHeight(*optionalHeight);
     return image.release();
 }
diff --git a/src/corelib/global/qglobal.h b/src/corelib/global/qglobal.h
index 20d88328..34ba4c2d 100644
--- a/src/corelib/global/qglobal.h
+++ b/src/corelib/global/qglobal.h
@@ -2482,22 +2482,32 @@ typedef uint Flags;
 
 #endif /* Q_NO_TYPESAFE_FLAGS */
 
-#if defined(Q_CC_GNU) && !defined(Q_CC_INTEL) && !defined(Q_CC_RVCT)
+#if (defined(Q_CC_GNU) && !defined(Q_CC_RVCT))
 /* make use of typeof-extension */
 template <typename T>
 class QForeachContainer {
 public:
-    inline QForeachContainer(const T& t) : c(t), brk(0), i(c.begin()), e(c.end()) { }
+    inline QForeachContainer(const T& t) : c(t), i(c.begin()), e(c.end()), control(1) { }
     const T c;
     int brk;
     typename T::const_iterator i, e;
+    int control;
 };
 
+// Explanation of the control word:
+//  - it's initialized to 1
+//  - that means both the inner and outer loops start
+//  - if there were no breaks, at the end of the inner loop, it's set to 0, which
+//    causes it to exit (the inner loop is run exactly once)
+//  - at the end of the outer loop, it's inverted, so it becomes 1 again, allowing
+//    the outer loop to continue executing
+//  - if there was a break inside the inner loop, it will exit with control still
+//    set to 1; in that case, the outer loop will invert it to 0 and will exit too
 #define Q_FOREACH(variable, container)                                \
 for (QForeachContainer<__typeof__(container)> _container_(container); \
-     !_container_.brk && _container_.i != _container_.e;              \
-     __extension__  ({ ++_container_.brk; ++_container_.i; }))                       \
-    for (variable = *_container_.i;; __extension__ ({--_container_.brk; break;}))
+     _container_.control && _container_.i != _container_.e;         \
+     ++_container_.i, _container_.control ^= 1)                     \
+    for (variable = *_container_.i; _container_.control; _container_.control = 0)
 
 #else
 
diff --git a/src/network/ssl/qsslcertificate.cpp b/src/network/ssl/qsslcertificate.cpp
index 0f2314e2..f8620374 100644
--- a/src/network/ssl/qsslcertificate.cpp
+++ b/src/network/ssl/qsslcertificate.cpp
@@ -259,10 +259,17 @@ void QSslCertificate::clear()
 QByteArray QSslCertificate::version() const
 {
     QMutexLocker lock(QMutexPool::globalInstanceGet(d.data()));
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
     if (d->versionString.isEmpty() && d->x509)
         d->versionString =
             QByteArray::number(qlonglong(q_ASN1_INTEGER_get(d->x509->cert_info->version)) + 1);
 
+#else
+    if (d->versionString.isEmpty() && d->x509) {
+        d->versionString =
+	    QByteArray::number(qlonglong(q_X509_get_version(d->x509)) + 1);
+    }
+#endif
     return d->versionString;
 }
 
@@ -276,7 +283,11 @@ QByteArray QSslCertificate::serialNumber() const
 {
     QMutexLocker lock(QMutexPool::globalInstanceGet(d.data()));
     if (d->serialNumberString.isEmpty() && d->x509) {
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
         ASN1_INTEGER *serialNumber = d->x509->cert_info->serialNumber;
+#else
+        ASN1_INTEGER *serialNumber = q_X509_get_serialNumber(d->x509);
+#endif
         // if we cannot convert to a long, just output the hexadecimal number
         if (serialNumber->length > 4) {
             QByteArray hexString;
@@ -489,19 +500,37 @@ QSslKey QSslCertificate::publicKey() const
     QSslKey key;
 
     key.d->type = QSsl::PublicKey;
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
     X509_PUBKEY *xkey = d->x509->cert_info->key;
+#else
+    X509_PUBKEY *xkey = q_X509_get_X509_PUBKEY(d->x509);
+#endif
     EVP_PKEY *pkey = q_X509_PUBKEY_get(xkey);
     Q_ASSERT(pkey);
 
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
     if (q_EVP_PKEY_type(pkey->type) == EVP_PKEY_RSA) {
+#else
+    int key_id;
+    key_id = q_EVP_PKEY_base_id(pkey);
+    if (key_id == EVP_PKEY_RSA) {
+#endif
         key.d->rsa = q_EVP_PKEY_get1_RSA(pkey);
         key.d->algorithm = QSsl::Rsa;
         key.d->isNull = false;
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
     } else if (q_EVP_PKEY_type(pkey->type) == EVP_PKEY_DSA) {
+#else
+    } else if (key_id == EVP_PKEY_DSA) {
+#endif
         key.d->dsa = q_EVP_PKEY_get1_DSA(pkey);
         key.d->algorithm = QSsl::Dsa;
         key.d->isNull = false;
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
     } else if (q_EVP_PKEY_type(pkey->type) == EVP_PKEY_DH) {
+#else
+    } else if (key_id == EVP_PKEY_DH) {
+#endif
         // DH unsupported
     } else {
         // error?
@@ -687,7 +716,11 @@ static QMap<QString, QString> _q_mapFromX509Name(X509_NAME *name)
         unsigned char *data = 0;
         int size = q_ASN1_STRING_to_UTF8(&data, q_X509_NAME_ENTRY_get_data(e));
         info[QString::fromUtf8(obj)] = QString::fromUtf8((char*)data, size);
+#if ((OPENSSL_VERSION_NUMBER < 0x10100000L) || (OPENSSL_VERSION_NUMBER >= 0x10101000L))
         q_CRYPTO_free(data);
+#else
+        q_OPENSSL_free(data);
+#endif
     }
     return info;
 }
diff --git a/src/network/ssl/qsslkey.cpp b/src/network/ssl/qsslkey.cpp
index 437a177b..133f724f 100644
--- a/src/network/ssl/qsslkey.cpp
+++ b/src/network/ssl/qsslkey.cpp
@@ -321,8 +321,18 @@ int QSslKey::length() const
 {
     if (d->isNull)
         return -1;
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
     return (d->algorithm == QSsl::Rsa)
            ? q_BN_num_bits(d->rsa->n) : q_BN_num_bits(d->dsa->p);
+#else
+    if (d->algorithm == QSsl::Rsa) {
+        return q_RSA_bits(d->rsa);
+    }else{
+        const BIGNUM *p = NULL;
+        q_DSA_get0_pqg(d->dsa, &p, NULL, NULL);
+	return q_BN_num_bits(p);
+    }
+#endif
 }
 
 /*!
diff --git a/src/network/ssl/qsslsocket_openssl.cpp b/src/network/ssl/qsslsocket_openssl.cpp
index ce984945..92d533f3 100644
--- a/src/network/ssl/qsslsocket_openssl.cpp
+++ b/src/network/ssl/qsslsocket_openssl.cpp
@@ -93,6 +93,7 @@ bool QSslSocketPrivate::s_libraryLoaded = false;
 bool QSslSocketPrivate::s_loadedCiphersAndCerts = false;
 bool QSslSocketPrivate::s_loadRootCertsOnDemand = false;
 
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
 /* \internal
 
     From OpenSSL's thread(3) manual page:
@@ -174,6 +175,7 @@ static unsigned long id_function()
 }
 } // extern "C"
 
+#endif //OPENSSL_VERSION_NUMBER >= 0x10100000L
 QSslSocketBackendPrivate::QSslSocketBackendPrivate()
     : ssl(0),
       ctx(0),
@@ -222,9 +224,13 @@ QSslCipher QSslSocketBackendPrivate::QSslCipher_from_SSL_CIPHER(SSL_CIPHER *ciph
             ciph.d->encryptionMethod = descriptionList.at(4).mid(4);
         ciph.d->exportable = (descriptionList.size() > 6 && descriptionList.at(6) == QLatin1String("export"));
 
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
         ciph.d->bits = cipher->strength_bits;
         ciph.d->supportedBits = cipher->alg_bits;
 
+#else
+	ciph.d->bits = q_SSL_CIPHER_get_bits(cipher, &ciph.d->supportedBits);
+#endif
     }
     return ciph;
 }
@@ -363,7 +369,11 @@ init_context:
         //
         // See also: QSslContext::fromConfiguration()
         if (caCertificate.expiryDate() >= QDateTime::currentDateTime()) {
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
             q_X509_STORE_add_cert(ctx->cert_store, (X509 *)caCertificate.handle());
+#else
+	    q_X509_STORE_add_cert(q_SSL_CTX_get_cert_store(ctx), (X509 *)caCertificate.handle());
+#endif
         }
     }
 
@@ -500,8 +510,10 @@ void QSslSocketBackendPrivate::destroySslContext()
 */
 void QSslSocketPrivate::deinitialize()
 {
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
     q_CRYPTO_set_id_callback(0);
     q_CRYPTO_set_locking_callback(0);
+#endif
 }
 
 /*!
@@ -522,13 +534,17 @@ bool QSslSocketPrivate::ensureLibraryLoaded()
         return false;
 
     // Check if the library itself needs to be initialized.
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
     QMutexLocker locker(openssl_locks()->initLock());
+#endif
     if (!s_libraryLoaded) {
         s_libraryLoaded = true;
 
         // Initialize OpenSSL.
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
         q_CRYPTO_set_id_callback(id_function);
         q_CRYPTO_set_locking_callback(locking_function);
+#endif
         if (q_SSL_library_init() != 1)
             return false;
         q_SSL_load_error_strings();
@@ -567,7 +583,9 @@ bool QSslSocketPrivate::ensureLibraryLoaded()
 
 void QSslSocketPrivate::ensureCiphersAndCertsLoaded()
 {
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
     QMutexLocker locker(openssl_locks()->initLock());
+#endif
     if (s_loadedCiphersAndCerts)
         return;
     s_loadedCiphersAndCerts = true;
@@ -659,13 +677,17 @@ void QSslSocketPrivate::resetDefaultCiphers()
     STACK_OF(SSL_CIPHER) *supportedCiphers = q_SSL_get_ciphers(mySsl);
     for (int i = 0; i < q_sk_SSL_CIPHER_num(supportedCiphers); ++i) {
         if (SSL_CIPHER *cipher = q_sk_SSL_CIPHER_value(supportedCiphers, i)) {
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
             if (cipher->valid) {
+#endif
                 QSslCipher ciph = QSslSocketBackendPrivate::QSslCipher_from_SSL_CIPHER(cipher);
                 if (!ciph.isNull()) {
                     if (!ciph.name().toLower().startsWith(QLatin1String("adh")))
                         ciphers << ciph;
                 }
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
             }
+#endif
         }
     }
 
diff --git a/src/network/ssl/qsslsocket_openssl_symbols.cpp b/src/network/ssl/qsslsocket_openssl_symbols.cpp
index 3ee71060..92b8f4df 100644
--- a/src/network/ssl/qsslsocket_openssl_symbols.cpp
+++ b/src/network/ssl/qsslsocket_openssl_symbols.cpp
@@ -111,16 +111,28 @@ DEFINEFUNC(int, ASN1_STRING_length, ASN1_STRING *a, a, return 0, return)
 DEFINEFUNC2(int, ASN1_STRING_to_UTF8, unsigned char **a, a, ASN1_STRING *b, b, return 0, return);
 DEFINEFUNC4(long, BIO_ctrl, BIO *a, a, int b, b, long c, c, void *d, d, return -1, return)
 DEFINEFUNC(int, BIO_free, BIO *a, a, return 0, return)
+#if OPENSSL_VERSION_NUMBER < 0x10101000L
 DEFINEFUNC(BIO *, BIO_new, BIO_METHOD *a, a, return 0, return)
+#else
+DEFINEFUNC(BIO *, BIO_new, const BIO_METHOD *a, a, return 0, return)
+#endif
 DEFINEFUNC2(BIO *, BIO_new_mem_buf, void *a, a, int b, b, return 0, return)
 DEFINEFUNC3(int, BIO_read, BIO *a, a, void *b, b, int c, c, return -1, return)
+#if OPENSSL_VERSION_NUMBER < 0x10101000L
 DEFINEFUNC(BIO_METHOD *, BIO_s_mem, void, DUMMYARG, return 0, return)
+#else
+DEFINEFUNC(const BIO_METHOD *, BIO_s_mem, void, DUMMYARG, return 0, return)
+#endif
 DEFINEFUNC3(int, BIO_write, BIO *a, a, const void *b, b, int c, c, return -1, return)
 DEFINEFUNC(int, BN_num_bits, const BIGNUM *a, a, return 0, return)
 DEFINEFUNC(int, CRYPTO_num_locks, DUMMYARG, DUMMYARG, return 0, return)
 DEFINEFUNC(void, CRYPTO_set_locking_callback, void (*a)(int, int, const char *, int), a, return, DUMMYARG)
 DEFINEFUNC(void, CRYPTO_set_id_callback, unsigned long (*a)(), a, return, DUMMYARG)
+#if ((OPENSSL_VERSION_NUMBER < 0x10101000L) || (OPENSSL_VERSION_NUMBER >= 0x10101000L))
 DEFINEFUNC(void, CRYPTO_free, void *a, a, return, DUMMYARG)
+#else
+DEFINEFUNC(void, OPENSSL_free, void *a, a, return, DUMMYARG)
+#endif
 DEFINEFUNC(void, DSA_free, DSA *a, a, return, DUMMYARG)
 #if  OPENSSL_VERSION_NUMBER < 0x00908000L
 DEFINEFUNC3(X509 *, d2i_X509, X509 **a, a, unsigned char **b, b, long c, c, return 0, return)
@@ -286,6 +298,23 @@ DEFINEFUNC(void, OPENSSL_add_all_algorithms_noconf, void, DUMMYARG, return, DUMM
 DEFINEFUNC(void, OPENSSL_add_all_algorithms_conf, void, DUMMYARG, return, DUMMYARG)
 DEFINEFUNC3(int, SSL_CTX_load_verify_locations, SSL_CTX *ctx, ctx, const char *CAfile, CAfile, const char *CApath, CApath, return 0, return)
 DEFINEFUNC(long, SSLeay, void, DUMMYARG, return 0, return)
+#if 1
+DEFINEFUNC(X509_STORE *, SSL_CTX_get_cert_store, const SSL_CTX *ctx, ctx, return 0, return)
+DEFINEFUNC(ASN1_INTEGER *, X509_get_serialNumber, X509 *x, x, return 0, return)
+#endif
+#if OPENSSL_VERSION_NUMBER >= 0x10100000L
+DEFINEFUNC(int, EVP_PKEY_id, const EVP_PKEY *pkey, pkey, return 0, return)
+DEFINEFUNC(int, EVP_PKEY_base_id, const EVP_PKEY *pkey, pkey, return 0, return)
+DEFINEFUNC2(int, SSL_CIPHER_get_bits, const SSL_CIPHER *cipher, cipher, int *alg_bits, alg_bits, return 0, return)
+DEFINEFUNC2(long, SSL_CTX_set_options, SSL_CTX *ctx, ctx, long options, options, return 0, return)
+DEFINEFUNC(long, X509_get_version, X509 *x, x, return 0, return)
+DEFINEFUNC(X509_PUBKEY *, X509_get_X509_PUBKEY, X509 *x, x, return 0, return)
+DEFINEFUNC(int, RSA_bits,  const RSA *rsa, rsa, return 0, return)
+DEFINEFUNC(int, DSA_security_bits, const DSA *dsa, dsa, return 0, return)
+DEFINEFUNC(ASN1_TIME *, X509_get_notAfter, X509 *x, x, return 0, return)
+DEFINEFUNC(ASN1_TIME *, X509_get_notBefore, X509 *x, x, return 0, return)
+DEFINEFUNC4(void, DSA_get0_pqg, const DSA *d, d, const BIGNUM **p, p, const BIGNUM **q, q, const BIGNUM **g, g, return, return)
+#endif
 
 #ifdef Q_OS_SYMBIAN
 #define RESOLVEFUNC(func, ordinal, lib) \
@@ -819,6 +848,24 @@ bool q_resolveOpenSslSymbols()
     RESOLVEFUNC(SSL_set_connect_state)
     RESOLVEFUNC(SSL_shutdown)
     RESOLVEFUNC(SSL_write)
+#if 1
+    RESOLVEFUNC(SSL_CTX_get_cert_store)
+    RESOLVEFUNC(X509_get_serialNumber)
+#endif
+#if OPENSSL_VERSION_NUMBER >= 0x10100000L
+    RESOLVEFUNC(SSL_CTX_ctrl)
+    RESOLVEFUNC(EVP_PKEY_id)
+    RESOLVEFUNC(EVP_PKEY_base_id)
+    RESOLVEFUNC(SSL_CIPHER_get_bits)
+    RESOLVEFUNC(SSL_CTX_set_options)
+    RESOLVEFUNC(X509_get_version)
+    RESOLVEFUNC(X509_get_X509_PUBKEY)
+    RESOLVEFUNC(RSA_bits)
+    RESOLVEFUNC(DSA_security_bits)
+    RESOLVEFUNC(DSA_get0_pqg)
+    RESOLVEFUNC(X509_get_notAfter)
+    RESOLVEFUNC(X509_get_notBefore)
+#endif
 #ifndef OPENSSL_NO_SSL2
     RESOLVEFUNC(SSLv2_client_method)
 #endif
diff --git a/src/network/ssl/qsslsocket_openssl_symbols_p.h b/src/network/ssl/qsslsocket_openssl_symbols_p.h
index 2bfe0632..0f99ec6b 100644
--- a/src/network/ssl/qsslsocket_openssl_symbols_p.h
+++ b/src/network/ssl/qsslsocket_openssl_symbols_p.h
@@ -59,6 +59,9 @@
 QT_BEGIN_NAMESPACE
 
 #define DUMMYARG
+#ifndef OPENSSL_NO_SSL2
+#define OPENSSL_NO_SSL2 1
+#endif
 
 #if !defined QT_LINKED_OPENSSL
 // **************** Shared declarations ******************
@@ -207,16 +210,28 @@ int q_ASN1_STRING_length(ASN1_STRING *a);
 int q_ASN1_STRING_to_UTF8(unsigned char **a, ASN1_STRING *b);
 long q_BIO_ctrl(BIO *a, int b, long c, void *d);
 int q_BIO_free(BIO *a);
+#if OPENSSL_VERSION_NUMBER < 0x10101000L
 BIO *q_BIO_new(BIO_METHOD *a);
+#else
+BIO *q_BIO_new(const BIO_METHOD *a);
+#endif
 BIO *q_BIO_new_mem_buf(void *a, int b);
 int q_BIO_read(BIO *a, void *b, int c);
+#if OPENSSL_VERSION_NUMBER < 0x10101000L
 BIO_METHOD *q_BIO_s_mem();
+#else
+const BIO_METHOD *q_BIO_s_mem();
+#endif
 int q_BIO_write(BIO *a, const void *b, int c);
 int q_BN_num_bits(const BIGNUM *a);
 int q_CRYPTO_num_locks();
 void q_CRYPTO_set_locking_callback(void (*a)(int, int, const char *, int));
 void q_CRYPTO_set_id_callback(unsigned long (*a)());
+#if ((OPENSSL_VERSION_NUMBER < 0x10101000L) || (OPENSSL_VERSION_NUMBER >= 0x10101000L))
 void q_CRYPTO_free(void *a);
+#else
+void q_OPENSSL_free(void *a);
+#endif
 void q_DSA_free(DSA *a);
 #if OPENSSL_VERSION_NUMBER >= 0x00908000L
 // 0.9.8 broke SC and BC by changing this function's signature.
@@ -326,7 +341,9 @@ void q_SSL_set_accept_state(SSL *a);
 void q_SSL_set_connect_state(SSL *a);
 int q_SSL_shutdown(SSL *a);
 #if OPENSSL_VERSION_NUMBER >= 0x10000000L
+#if 0
 const SSL_METHOD *q_SSLv2_client_method();
+#endif
 const SSL_METHOD *q_SSLv3_client_method();
 const SSL_METHOD *q_SSLv23_client_method();
 const SSL_METHOD *q_TLSv1_client_method();
@@ -335,7 +352,9 @@ const SSL_METHOD *q_SSLv3_server_method();
 const SSL_METHOD *q_SSLv23_server_method();
 const SSL_METHOD *q_TLSv1_server_method();
 #else
+#if 0
 SSL_METHOD *q_SSLv2_client_method();
+#endif
 SSL_METHOD *q_SSLv3_client_method();
 SSL_METHOD *q_SSLv23_client_method();
 SSL_METHOD *q_TLSv1_client_method();
@@ -399,7 +418,26 @@ DSA *q_d2i_DSAPrivateKey(DSA **a, unsigned char **pp, long length);
 		PEM_ASN1_write_bio((int (*)(void*, unsigned char**))q_i2d_DSAPrivateKey,PEM_STRING_DSA,\
 			bp,(char *)x,enc,kstr,klen,cb,u)
 #endif
+#if 1
+X509_STORE * q_SSL_CTX_get_cert_store(const SSL_CTX *ctx);
+ASN1_INTEGER * q_X509_get_serialNumber(X509 *x);
+#endif
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
 #define q_SSL_CTX_set_options(ctx,op) q_SSL_CTX_ctrl((ctx),SSL_CTRL_OPTIONS,(op),NULL)
+#if 1
+#define q_X509_get_version(x) X509_get_version(x)
+#endif
+#else
+int q_EVP_PKEY_id(const EVP_PKEY *pkey);
+int q_EVP_PKEY_base_id(const EVP_PKEY *pkey);
+int q_SSL_CIPHER_get_bits(const SSL_CIPHER *cipher, int *alg_bits);
+long q_SSL_CTX_set_options(SSL_CTX *ctx, long options);
+long q_X509_get_version(X509 *x);
+X509_PUBKEY * q_X509_get_X509_PUBKEY(X509 *x);
+int q_RSA_bits(const RSA *rsa);
+int q_DSA_security_bits(const DSA *dsa);
+void q_DSA_get0_pqg(const DSA *d, const BIGNUM **p, const BIGNUM **q, const BIGNUM **g);
+#endif
 #define q_SKM_sk_num(type, st) ((int (*)(const STACK_OF(type) *))q_sk_num)(st)
 #define q_SKM_sk_value(type, st,i) ((type * (*)(const STACK_OF(type) *, int))q_sk_value)(st, i)
 #define q_sk_GENERAL_NAME_num(st) q_SKM_sk_num(GENERAL_NAME, (st))
@@ -410,8 +448,13 @@ DSA *q_d2i_DSAPrivateKey(DSA **a, unsigned char **pp, long length);
 #define q_sk_SSL_CIPHER_value(st, i) q_SKM_sk_value(SSL_CIPHER, (st), (i))
 #define q_SSL_CTX_add_extra_chain_cert(ctx,x509) \
         q_SSL_CTX_ctrl(ctx,SSL_CTRL_EXTRA_CHAIN_CERT,0,(char *)x509)
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
 #define q_X509_get_notAfter(x) X509_get_notAfter(x)
 #define q_X509_get_notBefore(x) X509_get_notBefore(x)
+#else
+ASN1_TIME *q_X509_get_notAfter(X509 *x);
+ASN1_TIME *q_X509_get_notBefore(X509 *x);
+#endif
 #define q_EVP_PKEY_assign_RSA(pkey,rsa) q_EVP_PKEY_assign((pkey),EVP_PKEY_RSA,\
 					(char *)(rsa))
 #define q_EVP_PKEY_assign_DSA(pkey,dsa) q_EVP_PKEY_assign((pkey),EVP_PKEY_DSA,\
diff --git a/src/plugins/accessible/widgets/itemviews.cpp b/src/plugins/accessible/widgets/itemviews.cpp
index 14c9279d..54355b1a 100644
--- a/src/plugins/accessible/widgets/itemviews.cpp
+++ b/src/plugins/accessible/widgets/itemviews.cpp
@@ -393,7 +393,11 @@ bool QAccessibleTable2::unselectColumn(int column)
     QModelIndex index = view()->model()->index(0, column, view()->rootIndex());
     if (!index.isValid() || view()->selectionMode() & QAbstractItemView::NoSelection)
         return false;
+#if 0
     view()->selectionModel()->select(index, QItemSelectionModel::Columns & QItemSelectionModel::Deselect);
+#else
+    view()->selectionModel()->select(index, static_cast<QItemSelectionModel::SelectionFlags>(QItemSelectionModel::Columns & QItemSelectionModel::Deselect));
+#endif
     return true;
 }
 
diff --git a/tools/linguist/linguist/messagemodel.cpp b/tools/linguist/linguist/messagemodel.cpp
index 61c5389f..be42f12f 100644
--- a/tools/linguist/linguist/messagemodel.cpp
+++ b/tools/linguist/linguist/messagemodel.cpp
@@ -183,7 +183,11 @@ static int calcMergeScore(const DataModel *one, const DataModel *two)
         if (ContextItem *c = one->findContext(oc->context())) {
             for (int j = 0; j < oc->messageCount(); ++j) {
                 MessageItem *m = oc->messageItem(j);
+#if 0
                 if (c->findMessage(m->text(), m->comment()) >= 0)
+#else
+                if (c->findMessage(m->text(), m->comment()))
+#endif
                     ++inBoth;
             }
         }
