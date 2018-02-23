"""
Parallel resistors

form:
1/A1 + 1/A2 = 1/A3

Copyright (C) 2018 Dan White
"""
from pynomo.nomographer import *

AB_params_1={
    'tag':'ab',
        'u_min':0.0,
        'u_max':200.0,
        'function':lambda u:u,
        'title':r'$A_1$ $B_1$',
        'tick_levels':3,
        'tick_text_levels':1,
        'grid_length_0': 0.3,
        'grid_length_1': 0.25,
        'grid_length_2': 0.1,
        'text_distance_0': 0.35,
                }

A_params_2 = dict(AB_params_1)
A_params_2.update({
        'u_min':0.0,
        'u_max':250.0,
        'function':lambda u:u,
        'title':r'$A_2$',
        'tick_side':'left',
        }
)

A_params_3 = dict(AB_params_1)
A_params_3.update({
        'u_min':10.0,
        'u_max':112.0,
        'function':lambda u:u,
        'title':r'$A_3$',
        'tick_levels':3,
        'tick_text_levels':2,
        'grid_length_0': 0.2,
        'grid_length_1': 0.15,
        'text_distance_0': 0.25,
                }
)


block_A_params={
             'block_type':'type_7',
             'width':7.5,
             'height':10.0,
             'f1_params':AB_params_1,
             'f2_params':A_params_2,
             'f3_params':A_params_3,
             'angle_u':36.0/2,
             'angle_v':36.0/2,
             'isopleth_values':[[200,120,'x']],
             }




B_params_2={
        'u_min':2.0,
        'u_max':20.0,
        'function':lambda u:3*u,
        'title':r'$B_2$',
        'tick_levels':3,
        'tick_text_levels':1,
        'tick_side':'left',
        'grid_length_0': 0.3,
        'grid_length_1': 0.25,
        'grid_length_2': 0.1,
        'text_distance_0': 0.35,
                }

B_params_3 = dict(B_params_2)
B_params_3.update({
        'title':r'$B_3$',
        'tick_side':'right',
                }
)


block_B_params={
             'block_type':'type_7',
             'width':10.0,
             'height':10.0,
             'f1_params':AB_params_1,
             'f2_params':B_params_2,
             'f3_params':B_params_3,
             'angle_u':90-22,
             'angle_v':22,
             'isopleth_values':[[100,10,'y']],
             }

main_params={
              'filename':'nomogram_parallel.pdf',
              'paper_height':2*10.0,
              'paper_width':2*7.5,
              'block_params':[block_A_params, block_B_params],
              'transformations':[('rotate',90),('scale paper',)],
              'title_str':r'$1/A_1+1/A_2=1/A_3$',
            'title_x': 6,
            'title_y': 20,
    # 'make_grid': True,
              }

Nomographer(main_params)
