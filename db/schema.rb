# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160510181042) do

  create_table "logs", force: :cascade do |t|
    t.string   "message"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patient_states", force: :cascade do |t|
    t.string   "message"
    t.string   "registered"
    t.string   "msg_patient_registration"
    t.string   "patient_registration"
    t.string   "wait_for_specimen"
    t.string   "msg_specimen_received"
    t.string   "wait_for_nucleic_acid"
    t.string   "msg_nucleic_acid_sendout"
    t.string   "wait_for_variant_report"
    t.string   "msg_progression"
    t.string   "msg_off_trial"
    t.string   "msg_on_treatment_arm"
    t.string   "msg_treatment_arm_suspended"
    t.string   "msg_patient_not_eligible"
    t.string   "msg_specimen_failure"
    t.string   "msg_pten_ordered"
    t.string   "msg_pten_result"
    t.string   "msg_mlh1_ordered"
    t.string   "msg_mlh1_result"
    t.string   "msg_msh2_ordered"
    t.string   "msg_msh2_result"
    t.string   "msg_rb_ordered"
    t.string   "msg_rb_result"
    t.string   "msg_pathology_confirmation"
    t.string   "output"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

end
