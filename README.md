# beaglebone-pru-swig

JNI wrapper around the native code for interacting with the
beaglebone's PRUs

## Usage

You can get it from the clojars maven repo:
```
[beaglebone-pru-swig 1.0.0]
```

here is an example use from Clojure:

```clojure
(require '[clojure.java.io :as io])

(defn f []
  (let [f (java.io.File/createTempFile "libPRU" ".so")]
    (.deleteOnExit f)
    (io/copy (io/input-stream (io/resource "libPRU.so")) f)
    (com.thelastcitadel.pru.PRUJNI/load (.getAbsolutePath f))))

(f)

(import '(com.thelastcitadel.pru PRU
                                 SWIGTYPE_p_unsigned_int
                                 SWIGTYPE_p_p_void))

(defn pru-data-ram [unit]
  (case unit
    0 (let [x (PRU/new_unsinged_int_array 1)]
        (PRU/prussdrv_map_prumem PRU/PRUSS0_PRU0_DATARAM
          (SWIGTYPE_p_p_void.
            (SWIGTYPE_p_unsigned_int/getCPtr x)
            true))
        (let [n (PRU/unsinged_int_array_getitem x 0)]
          (PRU/delete_unsinged_int_array x)
          (SWIGTYPE_p_unsigned_int. n true)))
    1 (let [x (PRU/new_unsinged_int_array 1)]
        (PRU/prussdrv_map_prumem PRU/PRUSS0_PRU1_DATARAM 
          (SWIGTYPE_p_p_void.
            (SWIGTYPE_p_unsigned_int/getCPtr x)
            true))
        (let [n (PRU/unsinged_int_array_getitem x 0)]
          (PRU/delete_unsinged_int_array x)
          (SWIGTYPE_p_unsigned_int. n true)))))

(def addend1 0x0010F012)
(def addend2 0x0000567A)

(defn g []
  (println "1")
  (PRU/prussdrv_init)
  (PRU/prussdrv_open PRU/PRU_EVTOUT_0)
  (PRU/prussdrv_pruintc_init (PRU/pruss_intc_initdata_ptr_get))
  (println "2")
  (let [x (pru-data-ram 0)]
    (dotimes [i 10]
      (PRU/unsinged_int_array_setitem x i 0))
    (PRU/prussdrv_exec_program 0 "/home/root/bas.bin")
    (PRU/prussdrv_pru_wait_event PRU/PRU_EVTOUT_0)
    (println "3")
    (PRU/prussdrv_pru_clear_event PRU/PRU0_ARM_INTERRUPT)
    (dotimes [i 10]
      (println i "=" (PRU/unsinged_int_array_getitem x i))))
  (PRU/prussdrv_pru_clear_event 0)
  (PRU/prussdrv_pru_disable 0)
  (PRU/prussdrv_exit)
  (println "done"))

```


## License

Code and other files in `am335x_pru_package/` contain relevant
copyright notices, the terms are pretty decent, so don't be scared of
using this library.

Significant portions(most) of `swig/pru.i` are directly lifted from
code in `am335x_pru_package/` including the licensing header, because
it seems like the thing to do.

Everything else:

Copyright © 2014 Kevin Downey

Distributed under the Eclipse Public License, the same as Clojure.
