(ns experiment-clojurescript.core
    (:require [reagent.core :as reagent :refer [atom]]))

(enable-console-print!)

(println "This text is printed from src/experiment-clojurescript/core.cljs. Go ahead and edit it and see reloading in action.")

;; define your app data so that it doesn't get over-written on reload

(defonce app-state (atom {:text "Hello world!"}))
(defonce message (atom "My message"))


(defn render-message-input []
  [:input {
           :type "text"
           :value @message
           :on-change #(reset! message (-> % .-target .-value))
           }])
(defn hello-world []
  [:div
   [:h3 @message]
   [render-message-input]
   [:h3 "Edit this and watch it change!"]])

(reagent/render-component [hello-world]
                          (. js/document (getElementById "app")))

(defn on-js-reload []
  ;; optionally touch your app-state to force rerendering depending on
  ;; your application
  ;; (swap! app-state update-in [:__figwheel_counter] inc)
)
