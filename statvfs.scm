;; statvfs egg for CHICKEN Scheme

;; Copyright (c) 2010-2014 Mario Domenech Goulart
;; Copyright (c) 2008-2010 Ozzi Lee

;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use,
;; copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the
;; Software is furnished to do so, subject to the following
;; conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
;; OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
;; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
;; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;; OTHER DEALINGS IN THE SOFTWARE.

(module statvfs (statvfs)

(import scheme chicken foreign)
(use srfi-1 foreigners)

(foreign-declare "#include <sys/statvfs.h>")

;; Debian
;;
;; struct statvfs
;;   {
;;     unsigned long int f_bsize;
;;     unsigned long int f_frsize;
;; #ifndef __USE_FILE_OFFSET64
;;     __fsblkcnt_t f_blocks;
;;     __fsblkcnt_t f_bfree;
;;     __fsblkcnt_t f_bavail;
;;     __fsfilcnt_t f_files;
;;     __fsfilcnt_t f_ffree;
;;     __fsfilcnt_t f_favail;
;; #else
;;     __fsblkcnt64_t f_blocks;
;;     __fsblkcnt64_t f_bfree;
;;     __fsblkcnt64_t f_bavail;
;;     __fsfilcnt64_t f_files;
;;     __fsfilcnt64_t f_ffree;
;;     __fsfilcnt64_t f_favail;
;; #endif
;;     unsigned long int f_fsid;
;; #ifdef _STATVFSBUF_F_UNUSED
;;     int __f_unused;
;; #endif
;;     unsigned long int f_flag;
;;     unsigned long int f_namemax;
;;     int __f_spare[6];
;;   };

;; Mac OS X
;;
;; struct statvfs {
;;         unsigned long   f_bsize;        /* File system block size */
;;         unsigned long   f_frsize;       /* Fundamental file system block size */
;;         fsblkcnt_t      f_blocks;       /* Blocks on FS in units of f_frsize */
;;         fsblkcnt_t      f_bfree;        /* Free blocks */
;;         fsblkcnt_t      f_bavail;       /* Blocks available to non-root */
;;         fsfilcnt_t      f_files;        /* Total inodes */
;;         fsfilcnt_t      f_ffree;        /* Free inodes */
;;         fsfilcnt_t      f_favail;       /* Free inodes for non-root */
;;         unsigned long   f_fsid;         /* Filesystem ID */
;;         unsigned long   f_flag;         /* Bit mask of values */
;;         unsigned long   f_namemax;      /* Max file name length */
;; };

(define (statvfs path)

  (define c-statvfs
    (foreign-lambda int statvfs c-string c-pointer))

  (define-foreign-record-type (statvfs "struct statvfs")
    (constructor: make-statvfs)
    (destructor: free-statvfs)
    (unsigned-long f_bsize f_bsize)
    (unsigned-long f_frsize f_frsize)
    (unsigned-long f_blocks f_blocks)
    (unsigned-long f_bfree f_bfree)
    (unsigned-long f_bavail f_bavail)
    (unsigned-long f_files f_files)
    (unsigned-long f_ffree f_ffree)
    (unsigned-long f_favail f_favail)
    (unsigned-long f_fsid f_fsid)
    (unsigned-long f_flag f_flag)
    (unsigned-long f_namemax f_namemax))

  (let ((ptr (make-statvfs)))
    (c-statvfs path ptr)
    (let ((v (vector
              (f_bsize ptr)
              (f_frsize ptr)
              (f_blocks ptr)
              (f_bfree ptr)
              (f_bavail ptr)
              (f_files ptr)
              (f_ffree ptr)
              (f_favail ptr)
              (f_fsid ptr)
              (f_flag ptr)
              (f_namemax ptr))))
      (free-statvfs ptr)
      v)))

) ;; end module