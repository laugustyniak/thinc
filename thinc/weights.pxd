from libc.stdint cimport uint64_t
from libc.stdint cimport uint32_t
from libc.stdint cimport uint16_t

from cymem.cymem cimport Pool

from preshed.maps cimport PreshMap
from preshed.maps cimport PreshMapArray
from preshed.maps cimport MapStruct
from preshed.maps cimport Cell


# Number of weights in a line. Should be aligned to cache lines.
DEF LINE_SIZE = 8

ctypedef int weight_t

# Typedef numeric types, to make them easier to change and ensure consistency
ctypedef uint64_t feat_t
ctypedef uint32_t class_t
ctypedef uint32_t count_t
ctypedef uint32_t time_t


ctypedef weight_t[LINE_SIZE] weight_line_t


# A set of weights, to be read in. Start indicates the class that w[0] refers
# to. Subsequent weights go from there.
cdef struct WeightLine:
    int start
    weight_line_t line


cdef struct MetaData:
    weight_t total
    count_t count
    time_t time
    

cdef struct TrainFeat:
    size_t length
    WeightLine** weights
    MetaData** meta


cdef int average_weight(TrainFeat* feat, const class_t nr_class, const time_t time) except -1
cdef TrainFeat* new_train_feat(Pool mem, const class_t nr_class) except NULL
cdef int update_feature(Pool mem, TrainFeat* feat, class_t clas, weight_t upd,
                        time_t time) except -1
cdef count_t get_total_count(TrainFeat* feat, const class_t n) except 0
cdef class_t arg_max(weight_t* scores, class_t n_classes) except 0
cdef class_t gather_weights(MapStruct* maps, class_t nr_class,
                            WeightLine** w_lines,
                            feat_t* feat_ids, weight_t* values) nogil
cdef int set_scores(weight_t* scores, WeightLine** weight_lines,
                    class_t nr_rows, class_t nr_class) except -1
 
cdef class_t get_nr_rows(const class_t n) nogil
