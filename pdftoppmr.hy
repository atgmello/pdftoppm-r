(import os subprocess argparse [functools [partial]])


(defn convert [file quality resolution]
  (setv command f"pdftoppm -jpeg -jpegopt
                    quality={quality} -r {resolution}
                    {file}
                    {(cut file 0 -4)}")
  (setv converter
        (-> command
            .split
            subprocess.run))
  ;; If something went wrong, raise error
  ;; Else, return a tuple with the original
  ;; file name and the one that was created,
  ;; which should equal the original one but
  ;; with "-1.jpg" appended to the end
  (if (= 0 converter.returncode)
      (, file (+ (cut file 0 -4) "-1.jpg"))
      (raise (Exception f"{stderr}"))))


(defn get-filenames [dirname]
  (lfor x
        (os.walk dirname)
        (if (get x 2)
            ;; If there are files in this folder,
            ;; join them with the directory name
            (lfor y
                  (get x 2)
                  (os.path.join (get x 0) y))
            ;; If not, recur
            (lfor y
                  (get x 2)
                  (get-filenames y)))))


(defn remove-rename [pdf jpg]
  (os.remove pdf)
  (os.rename jpg (+ (cut jpg 0 -6) ".jpg")))


(defmain [&rest _]
  ;; Parse
  (setv parser (argparse.ArgumentParser))
  (.add-argument parser "STRING"
                 :help "folder containing the PDF files")
  (.add-argument parser "-q" :type int :default 100
                 :help "conversion quality; default value: 100")
  (.add-argument parser "-r" :type int :default 300
                 :help "conversion resolution; default value: 300")
  (setv args (parser.parse_args))
  ;; Convert
  (setv pdf-jpg-tuples
        (lfor file
              (filter (fn [f] (= ".pdf" (cut f -4 None)))
                (flatten (get-filenames args.STRING)))
              (convert file args.q args.r)))
  ;; Clean-up
  (lfor pdf-jpg
        pdf-jpg-tuples
        (remove-rename (unpack-iterable pdf-jpg)))
  ;; Exit
  0)
